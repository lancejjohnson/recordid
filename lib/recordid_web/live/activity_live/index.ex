defmodule RecordidWeb.ActivityLive.Index do
  use RecordidWeb, :live_view

  alias Recordid.Activities

  @impl true
  def mount(_params, _session, socket) do
    %{current_user: user} = socket.assigns
    {:ok, stream(socket, :activities, Activities.list_activities(user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    %{current_user: user, live_action: action} = socket.assigns
    {:noreply, apply_action(socket, user, action, params)}
  end

  defp apply_action(socket, user, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, Activities.get_activity!(user, id))
  end

  defp apply_action(socket, user, :new, _params) do
    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, Activities.new_activity(user))
  end

  defp apply_action(socket, _user, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activities")
    |> assign(:activity, nil)
  end

  @impl true
  def handle_info({RecordidWeb.ActivityLive.FormComponent, {:saved, activity}}, socket) do
    {:noreply, stream_insert(socket, :activities, activity)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    %{current_user: user} = socket.assigns
    activity = Activities.get_activity!(user, id)
    {:ok, _} = Activities.delete_activity(activity)

    {:noreply, stream_delete(socket, :activities, activity)}
  end
end
