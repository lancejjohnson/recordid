defmodule RecordidWeb.DayLive do
  use RecordidWeb, :live_view

  alias Recordid.Activities

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, %{assigns: %{current_user: current_user}} = socket) do
    days = Activities.list_days_with_activities(current_user)

    socket =
      socket
      |> assign(:days, days)
      # TODO(lancejjohnson): Replace UTC today with time zone aware
      |> assign(:today, Date.utc_today())

    {:noreply, socket}
  end
end
