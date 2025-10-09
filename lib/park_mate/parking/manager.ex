defmodule ParkMate.Parking.Manager do
  use GenServer
  require Logger
  alias ParkMate.Parking.ParkingLogs

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_all_spaces() do
    GenServer.call(__MODULE__, :get_all_spaces)
  end

  def get_free_spaces() do
    GenServer.call(__MODULE__, :get_free_spaces)
  end

  def get_parked_vehicle(floor, spot) do
    GenServer.call(__MODULE__, {:get_parked_vehicle, floor, spot})
  end

  def park(floor, spot, vehicle) do
    GenServer.call(__MODULE__, {:park, floor, spot, vehicle})
  end

  def unpark(floor, spot) do
    GenServer.call(__MODULE__, {:unpark, floor, spot})
  end

  def init(_opts) do
    Logger.info("Starting Parking Manager...")

    Logger.info("Starting Parking Logs...")
    ParkingLogs.start_link()

    {:ok, %{parking_spaces: ParkMate.Parking.Space.parking_spaces()}}
  end

  def handle_call(:get_all_spaces, _from, %{parking_spaces: parking_spaces} = state) do
    {:reply, parking_spaces, state}
  end

  def handle_call(:get_free_spaces, _from, %{parking_spaces: parking_spaces} = state) do
    free_spaces =
      parking_spaces
      |> Enum.map(fn {floor, spots} ->
        {floor, Map.filter(spots, fn {_spot, spot_value} -> spot_value.status == :free end)}
      end)
      |> Enum.into(%{})

    {:reply, free_spaces, state}
  end

  def handle_call(
        {:get_parked_vehicle, floor, spot},
        _from,
        %{parking_spaces: parking_spaces} = state
      ) do
    {:reply, get_parked_vehicle(parking_spaces, floor, spot), state}
  end

  def handle_call({:park, floor, spot, vehicle}, _from, %{parking_spaces: parking_spaces} = state) do
    case check_for_availability(parking_spaces, floor, spot) do
      :free ->
        parking_spaces =
          Map.update!(parking_spaces, floor, fn floor_value ->
            Map.put(floor_value, spot, %{status: :occupied, vehicle: vehicle})
          end)

        ParkingLogs.park(vehicle, floor, spot, NaiveDateTime.utc_now())

        {:reply, :ok, %{parking_spaces: parking_spaces}}

      status ->
        {:reply, {:error, status}, state}
    end
  end

  def handle_call({:unpark, floor, spot}, _from, %{parking_spaces: parking_spaces} = state) do
    vehicle = get_parked_vehicle(parking_spaces, floor, spot)

    case ParkingLogs.get_latest_log(vehicle) do
      nil ->
        Logger.error("Vehicle not parked - #{vehicle}")
        {:reply, {:error, "Vehicle not parked"}, state}

      parking_log ->
        ParkingLogs.unpark(parking_log, NaiveDateTime.utc_now())

        parking_spaces =
          Map.update!(parking_spaces, floor, fn floor_value ->
            Map.put(floor_value, spot, %{status: :free, vehicle: nil})
          end)

        {:reply, :ok, %{parking_spaces: parking_spaces}}
    end
  end

  defp check_for_availability(parking_spaces, floor, spot) do
    parking_spaces[floor][spot][:status]
  end

  defp get_parked_vehicle(parking_spaces, floor, spot) do
    parking_spaces
    |> Map.get(floor, %{})
    |> Map.get(spot, %{})
    |> Map.get(:vehicle, nil)
  end
end
