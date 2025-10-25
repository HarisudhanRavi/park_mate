defmodule ParkMateWeb.Parking.FloorsLive do
  use ParkMateWeb, :live_view
  alias ParkMate.Parking.Manager

  def mount(_params, _session, socket) do
    floors =
      Manager.get_all_spaces()
      |> Map.keys()

    {:ok, assign(socket, :floors, floors)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl font-extrabold dark:text-white mb-4">Parking</h1>

      <div class="w-full max-w-sm p-4 bg-white border border-gray-200 rounded-lg shadow-sm sm:p-6 dark:bg-gray-800 dark:border-gray-700">
        <h5 class="mb-3 text-base font-semibold text-gray-900 md:text-xl dark:text-white">
          Select a floor
        </h5>
        <ul class="my-4 space-y-3">
          <%= for floor <- @floors do %>
            <li>
              <.link
                navigate={~p"/parking/spots?floor=#{floor}"}
                class="flex items-center p-3 text-base font-bold text-gray-900 rounded-lg bg-gray-50 hover:bg-gray-100 group hover:shadow dark:bg-gray-600 dark:hover:bg-gray-500 dark:text-white"
              >
                <.icon name="hero-building-office" />
                <span class="flex-1 ms-3 whitespace-nowrap">{readable(floor)}</span>
              </.link>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  defp readable(atom) do
    to_string(atom) |> String.replace("_", " ") |> String.capitalize()
  end
end
