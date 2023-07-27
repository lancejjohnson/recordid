defmodule Recordid.Activities.Duration do
  defstruct days: 0, hours: 0, minutes: 0

  @seconds_in_day 24 * 60 * 60
  @seconds_in_hour 60 * 60
  @seconds_in_minute 60

  def from_activity(%{date_started: ds, date_finished: df, time_started: ts, time_finished: tf})
      when is_nil(ds) or is_nil(df) or is_nil(ts) or is_nil(tf) do
    {:error, %__MODULE__{}}
  end

  def from_activity(activity) do
    with {:ok, datetime_started} <- DateTime.new(activity.date_started, activity.time_started),
         {:ok, datetime_finished} <- DateTime.new(activity.date_finished, activity.time_finished),
         diff_in_seconds <- DateTime.diff(datetime_finished, datetime_started) do
      {:ok,
       %__MODULE__{}
       |> put_days(diff_in_seconds)
       |> put_hours(diff_in_seconds)
       |> put_minutes(diff_in_seconds)}
    else
      _ -> {:error, %__MODULE__{}}
    end
  end

  def to_string(%__MODULE__{} = duration) do
    [:days, :hours, :minutes]
    |> Enum.map(&field_to_string(&1, duration))
    |> Enum.join(" ")
    |> String.trim()
  end

  defp field_to_string(field, duration) do
    case Map.get(duration, field) do
      value when value in [0, nil] -> ""
      value -> "#{value}#{field_abbreviation(field)}"
    end
  end

  defp field_abbreviation(field) do
    field
    |> Atom.to_string()
    |> String.first()
  end

  defp put_days(duration, seconds) do
    days = div(seconds, @seconds_in_day)
    %{duration | days: days}
  end

  defp put_hours(duration, seconds) do
    hours =
      seconds
      |> rem(@seconds_in_day)
      |> div(@seconds_in_hour)

    %{duration | hours: hours}
  end

  defp put_minutes(duration, seconds) do
    minutes =
      seconds
      |> rem(@seconds_in_day)
      |> rem(@seconds_in_hour)
      |> div(@seconds_in_minute)

    %{duration | minutes: minutes}
  end
end
