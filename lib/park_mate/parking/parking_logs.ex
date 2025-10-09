defmodule ParkMate.Parking.ParkingLogs do
  def start_link() do
    :ets.new(__MODULE__, [:bag, :protected, :named_table])
  end

  def get_all_logs() do
    :ets.tab2list(__MODULE__)
  end

  def get_all_logs(vehicle) do
    :ets.lookup(__MODULE__, vehicle)
  end

  def get_latest_log(vehicle) do
    :ets.lookup(__MODULE__, vehicle)
    |> Enum.max_by(fn {_, _, _, park_time, _} -> park_time end, NaiveDateTime, fn -> nil end)
  end

  def park(vehicle, floor, spot, park_time) do
    true = :ets.insert(__MODULE__, {vehicle, floor, spot, park_time, nil})
  end

  def unpark(park_log, unpark_time) do
    true = :ets.delete_object(__MODULE__, park_log)
    true = :ets.insert(__MODULE__, Kernel.put_elem(park_log, 4, unpark_time))
  end
end
