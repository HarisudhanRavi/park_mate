defmodule ParkMate.Parking.Manager do
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    Logger.info("Starting Parking Manager...")

    {:ok, []}
  end
end
