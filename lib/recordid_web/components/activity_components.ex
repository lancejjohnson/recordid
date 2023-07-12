defmodule RecordidWeb.ActivityComponents do
  use Phoenix.Component
  alias Recordid.Activities.Activity
  alias Recordid.Activities.Duration

  attr :started_at, Time, required: false, default: nil
  attr :finished_at, Time, required: false, default: nil

  def time_range(%{started_at: nil, finished_at: nil} = assigns) do
    ~H"""
    <span></span>
    """
  end

  def time_range(assigns) do
    ~H"""
    <div>
      <span><%= format_time(@started_at) %></span><span>&ndash;</span><span><%= format_time(@finished_at) %></span>
    </div>
    """
  end

  attr :activity, Activity, required: true

  def time_duration(assigns) do
    ~H"""
    <span class="text-xs font-semibold text-slate-400"><%= activity_duration(@activity) %></span>
    """
  end

  defp activity_duration(activity) do
    case Duration.from_activity(activity) do
      {:ok, duration} -> Duration.to_string(duration)
      _ -> ""
    end
  end

  defp format_time(nil) do
    ""
  end

  defp format_time(%Time{} = time) do
    time
    |> Time.to_string()
    |> binary_slice(0, 5)
  end
end
