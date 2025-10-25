defmodule ParkMateWeb.Parking.SpotsLive do
  use ParkMateWeb, :live_view

  def mount(%{"floor" => _floor}, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl font-extrabold dark:text-white mb-4">Parking</h1>
    </div>
    """
  end
end
