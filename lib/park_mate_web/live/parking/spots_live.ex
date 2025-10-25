defmodule ParkMateWeb.Parking.SpotsLive do
  use ParkMateWeb, :live_view
  alias ParkMate.Parking.Manager

  def mount(%{"floor" => floor}, _session, socket) do
    floor = String.to_existing_atom(floor)

    spots = Manager.get_all_spaces() |> Map.get(floor) |> convert_status_to_color()

    {:ok, socket |> assign(:floor, floor) |> assign(:spots, spots)}
  end

  def mount(_params, _session, socket) do
    {:ok,
     push_navigate(socket, to: ~p"/parking/floors")
     |> put_flash(:error, "Select a valid floor")}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl font-extrabold dark:text-white mb-4">Parking</h1>

      <div class="block max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow-sm dark:bg-gray-800 dark:border-gray-700">
        <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
          Select a spot to park
        </h5>
        <%= for {_spot_name, spot_details} <- @spots do %>
          <span phx-click="" class="cursor-pointer mx-4">
            <.icon name="hero-square-2-stack-solid" class={spot_details.status} />
          </span>
        <% end %>
      </div>
    </div>
    """
  end

  defp convert_status_to_color(spots) do
    Enum.map(spots, fn {spot_name, details} ->
      {spot_name, %{details | status: status_color(details.status)}}
    end)
  end

  defp status_color(:free), do: "text-green-500 hover:text-green-700"
  defp status_color(:occupied), do: "text-red-500 hover:text-red-700"
end
