defmodule RecordidWeb.DayActivityLive do
  use RecordidWeb, :live_view
  import RecordidWeb.ActivityComponents, only: [time_range: 1, time_duration: 1]

  alias Recordid.Activities
  alias RecordidWeb.ActivityLive.FormComponent

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"date" => date} = unsigned_params, _uri, socket) do
    socket =
      socket
      |> assign(:date, date)
      |> stream(:activities, list_activities(date))

    {:noreply, apply_action(socket, socket.assigns.live_action, unsigned_params)}
  end

  defp list_activities(date) do
    Activities.list_activities_for_date(date)
  end

  defp apply_action(socket, :new, _params) do
    activity = Activities.new_activity()

    socket
    |> assign(:page_title, "New activity")
    |> assign(:activity, activity)
  end

  defp apply_action(socket, :edit, %{"id" => id} = _params) do
    activity = Activities.get_activity!(id)

    socket
    |> assign(:page_title, "Edit activity")
    |> assign(:activity, activity)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing activities")
    |> assign(:activity, nil)
  end

  @impl Phoenix.LiveView
  def handle_event("start_activity", %{"current_time" => time} = _unsigned_params, socket) do
    attrs = %{"time_started" => time, "date_started" => socket.assigns.date}

    case Activities.create_activity(attrs) do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> stream(:activities, list_activities(socket.assigns.date), reset: true)
         |> put_flash(:info, "Activity created successfully")}

      {:error, _cset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Could not create activity")}
    end
  end

  def handle_event("delete", %{"id" => activity_id} = _params, socket) do
    activity = Activities.get_activity!(activity_id)

    case Activities.delete_activity(activity) do
      {:ok, _activity} ->
        {:noreply, push_patch(socket, ~p"/days/#{socket.assigns.date}")}

      {:error, _changeset} ->
        {:noreply, push_patch(socket, ~p"/days/#{socket.assigns.date}")}
    end
  end

  @impl true
  def handle_info({FormComponent, {:saved, _activity}}, socket) do
    activities = list_activities(socket.assigns.date)
    {:noreply, stream(socket, :activities, activities, reset: true)}
  end

  def handle_info({FormComponent, {:deleted_activity, _activity}}, socket) do
    activities = list_activities(socket.assigns.date)
    {:noreply, stream(socket, :activities, activities, reset: true)}
  end

  def handle_info({FormComponent, {:delete_activity_failed, _activity}}, socket) do
    activities = list_activities(socket.assigns.date)
    {:noreply, stream(socket, :activities, activities, reset: true)}
  end
end
