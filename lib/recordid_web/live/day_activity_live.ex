defmodule RecordidWeb.DayActivityLive do
  use RecordidWeb, :live_view
  import RecordidWeb.ActivityComponents, only: [time_range: 1, time_duration: 1]

  alias Recordid.Activities
  alias RecordidWeb.ActivityLive.FormComponent

  @impl Phoenix.LiveView
  def mount(_params, session, %{assigns: assigns} = socket) do
    time_zone = get_time_zone(session, get_connect_params(socket), assigns[:current_user])
    {:ok, assign(socket, :time_zone, time_zone)}
  end

  defp get_time_zone(session, connect_params, %{time_zone: user_time_zone}) do
    session[:time_zone] || connect_params["time_zone"] || user_time_zone
  end

  # The unsigned_params are the params from the router. "date" comes from the URL param.
  @impl Phoenix.LiveView
  def handle_params(%{"date" => date} = unsigned_params, _uri, socket) do
    %{current_user: current_user} = socket.assigns

    socket =
      socket
      |> assign(:date, date)
      |> stream(:activities, Activities.list_activities_for_date(current_user, date))

    {:noreply, apply_action(socket, socket.assigns.live_action, unsigned_params)}
  end

  defp apply_action(socket, :new, _params) do
    %{current_user: current_user} = socket.assigns
    activity = Activities.new_activity(current_user)

    socket
    |> assign(:page_title, "New activity")
    |> assign(:activity, activity)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    %{current_user: current_user} = socket.assigns
    activity = Activities.get_activity!(current_user, id)

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
    %{current_user: current_user, date: date} = socket.assigns

    attrs = %{
      "time_started" => time,
      "date_started" => date,
      "user_id" => current_user.id
    }

    case Activities.create_activity(attrs) do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> stream(:activities, Activities.list_activities_for_date(current_user, date), reset: true)
         |> put_flash(:info, "Activity created successfully")}

      {:error, _cset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Could not create activity")}
    end
  end

  def handle_event("delete", %{"id" => activity_id} = _params, socket) do
    %{current_user: current_user} = socket.assigns
    activity = Activities.get_activity!(current_user, activity_id)

    case Activities.delete_activity(activity) do
      {:ok, _activity} ->
        {:noreply, push_patch(socket, ~p"/days/#{socket.assigns.date}")}

      {:error, _changeset} ->
        {:noreply, push_patch(socket, ~p"/days/#{socket.assigns.date}")}
    end
  end

  @impl true
  def handle_info({FormComponent, {:saved, _activity}}, socket) do
    %{current_user: current_user, date: date} = socket.assigns
    activities = Activities.list_activities_for_date(current_user, date)
    {:noreply, stream(socket, :activities, activities, reset: true)}
  end

  def handle_info({FormComponent, {:deleted_activity, _activity}}, socket) do
    %{current_user: current_user, date: date} = socket.assigns
    activities = Activities.list_activities_for_date(current_user, date)
    {:noreply, stream(socket, :activities, activities, reset: true)}
  end

  def handle_info({FormComponent, {:delete_activity_failed, _activity}}, socket) do
    %{current_user: current_user, date: date} = socket.assigns
    activities = Activities.list_activities_for_date(current_user, date)
    {:noreply, stream(socket, :activities, activities, reset: true)}
  end
end
