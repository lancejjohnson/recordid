defmodule RecordidWeb.ActivityLive.FormComponent do
  use RecordidWeb, :live_component

  alias Recordid.Activities

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="activity-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="flex flex-wrap gap-1">
          <div class="flex-grow">
            <.label>Started</.label>
            <.input field={@form[:time_started]} type="time" />
          </div>
          <div class="flex-grow">
            <.label>Finished</.label>
            <.input field={@form[:time_finished]} type="time" />
          </div>
          <div class="w-full">
            <.label>Description</.label>
            <.input field={@form[:description]} type="textarea" />
          </div>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Activity</.button>
          <div class="flex-grow">
            <.link
              phx-click={JS.push("delete", value: %{id: @activity.id})}
              phx-target={@myself}
              data-confirm="Are you sure?"
              class="text-sm text-red-500 border border-red-500 px-3 py-2 rounded-lg group hover:bg-red-600 hover:text-white"
            >
              <.icon name="hero-trash" class="bg-red-500 group-hover:bg-white" /> Delete
            </.link>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{activity: activity} = assigns, socket) do
    changeset = Activities.change_activity(activity)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    changeset =
      socket.assigns.activity
      |> Activities.change_activity(activity_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"activity" => activity_params}, socket) do
    save_activity(socket, socket.assigns.action, activity_params)
  end

  def handle_event("delete", params, socket) do
    delete_activity(socket, params)
  end

  defp save_activity(socket, :edit, activity_params) do
    case Activities.update_activity(socket.assigns.activity, activity_params) do
      {:ok, activity} ->
        notify_parent({:saved, activity})

        {:noreply,
         socket
         |> put_flash(:info, "Activity updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_activity(socket, :new, activity_params) do
    activity_params = add_date(activity_params, socket.assigns)

    case Activities.create_activity(activity_params) do
      {:ok, activity} ->
        notify_parent({:saved, activity})

        {:noreply,
         socket
         |> put_flash(:info, "Activity created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp delete_activity(socket, %{"id" => id}) do
    activity = Activities.get_activity!(id)

    case Activities.delete_activity(activity) do
      {:ok, activity} ->
        notify_parent({:deleted_activity, activity})

        socket =
          socket
          |> put_flash(:info, "Activity deleted")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, changeset} ->
        notify_parent({:delete_activity_failed, changeset})

        socket =
          socket
          |> put_flash(:info, "Activity could not be deleted")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp add_date(params, assigns) do
    date = Map.get(assigns, :date, Date.utc_today())

    params
    |> Map.put_new("date_started", date)
    |> Map.put_new("date_finished", date)
  end
end
