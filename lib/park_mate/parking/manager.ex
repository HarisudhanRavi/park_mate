defmodule ParkMate.Parking.Manager do
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_spaces() do
    GenServer.call(__MODULE__, :get_spaces)
  end

  def park(floor, spot, vehicle) do
    GenServer.call(__MODULE__, {:park, floor, spot, vehicle})
  end

  def init(_opts) do
    Logger.info("Starting Parking Manager...")

    {:ok, %{parking_spaces: ParkMate.Parking.Space.parking_spaces()}}
  end

  def handle_call(:get_spaces, _from, %{parking_spaces: parking_spaces} = state) do
    {:reply, parking_spaces, state}
  end

  def handle_call({:park, floor, spot, vehicle}, _from, %{parking_spaces: parking_spaces} = state) do
    case check_for_availability(parking_spaces, floor, spot) do
      :free ->
        parking_spaces =
          Map.update!(parking_spaces, floor, fn floor_value ->
            Map.put(floor_value, spot, %{status: :occupied, vehicle: vehicle})
          end)

        {:reply, :ok, %{parking_spaces: parking_spaces}}

      status ->
        {:reply, {:error, status}, state}
    end
  end

  defp check_for_availability(parking_spaces, floor, spot) do
    parking_spaces[floor][spot][:status]
  end
end
