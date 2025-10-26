defmodule ParkMateWeb.Parking.ParkForm do
  use ParkMateWeb, :live_component

  def update(assigns, socket) do
    {:ok, assign(socket, assigns) |> assign(:form, %{})}
  end

  def handle_event("park", %{"vehicle" => vehicle}, socket) do
    %{floor: floor, spot: spot} = socket.assigns

    case ParkMate.Parking.Manager.park(floor, spot, vehicle) do
      :ok ->
        send(self(), {:close_park, :info, "Parked"})

      {:error, reason} ->
        send(self(), {:close_park, :error, reason})
    end

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div :if={@show} id={@id} class="relative z-50">
        <div
          id={"#{@id}-bg"}
          class="bg-zinc-50/90 fixed inset-0 transition-opacity"
          aria-hidden="true"
        />
        <div
          class="fixed inset-0 overflow-y-auto"
          aria-labelledby={"#{@id}-title"}
          aria-describedby={"#{@id}-description"}
          role="dialog"
          aria-modal="true"
          tabindex="0"
        >
          <div class="flex min-h-full items-center justify-center">
            <div class="w-full max-w-lg sm:p-6 lg:py-8">
              <.focus_wrap
                phx-click-away="close_park"
                id={"#{@id}-container"}
                class="shadow-zinc-700/10 ring-zinc-700/10 relative rounded-2xl bg-white p-8 pt-4 shadow-lg ring-1 transition"
              >
                <div class="absolute top-6 right-5">
                  <button
                    phx-click="close_park"
                    type="button"
                    class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                    aria-label={gettext("close")}
                  >
                    <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                  </button>
                </div>
                <div id={"#{@id}-content"}>
                  <.simple_form for={%{}} phx-submit="park" phx-target={@myself}>
                    <.input
                      field={@form[:vehicle]}
                      name="vehicle"
                      value=""
                      label="Vehicle number"
                      required
                    />
                    <:actions>
                      <button
                        type="submit"
                        class="focus:outline-none text-white bg-green-700 hover:bg-green-800 focus:ring-4 focus:ring-green-300 font-medium rounded-lg text-sm ml-[40%] px-5 py-2.5 me-2 mb-2 dark:bg-green-600 dark:hover:bg-green-700 dark:focus:ring-green-800"
                      >
                        Park
                      </button>
                    </:actions>
                  </.simple_form>
                </div>
              </.focus_wrap>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
