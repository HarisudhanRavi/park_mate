defmodule ParkMate.Parking.Manager do
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_spaces() do
    GenServer.call(__MODULE__, :get_spaces)
  end

  def init(_opts) do
    Logger.info("Starting Parking Manager...")

    {:ok, %{parking_spaces: ParkMate.Parking.Space.parking_spaces()}}
  end

  def handle_call(:get_spaces, _from, %{parking_spaces: parking_spaces} = state) do
    {:reply, parking_spaces, state}
  end
end
