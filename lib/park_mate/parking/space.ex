defmodule ParkMate.Parking.Space do
  @parking_spaces %{
    floor_1: %{spot_1: %{status: :free, vehicle: nil}, spot_2: %{status: :free, vehicle: nil}},
    floor_2: %{spot_1: %{status: :free, vehicle: nil}, spot_2: %{status: :free, vehicle: nil}}
  }

  def parking_spaces(), do: @parking_spaces

  # ParkMate.Parking.Manager.get_spaces()
  # ParkMate.Parking.Manager.park(:floor_1, :spot_1, "TN001")
end
