defmodule Recordid.Activities.DurationTest do
  use Recordid.DataCase, async: true

  alias Recordid.Activities.Activity
  alias Recordid.Activities.Duration

  describe "from_activity/1" do
    test "with sub-minute duration" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        time_started: ~T[00:01:00],
        time_finished: ~T[00:01:59],
        date_started: date,
        date_finished: date
      }

      {:ok, duration} = Duration.from_activity(activity)

      assert duration.days == 0
      assert duration.hours == 0
      assert duration.minutes == 0
    end

    test "with minute duration" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        time_started: ~T[00:01:00],
        time_finished: ~T[00:02:00],
        date_started: date,
        date_finished: date
      }

      {:ok, duration} = Duration.from_activity(activity)

      assert %Duration{days: 0, hours: 0, minutes: 1} = duration
    end

    test "with sub-hour duration" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        time_started: ~T[00:00:01],
        time_finished: ~T[00:59:59],
        date_started: date,
        date_finished: date
      }

      {:ok, duration} = Duration.from_activity(activity)

      assert %Duration{days: 0, hours: 0, minutes: 59} = duration
    end

    test "with sub-day duration" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        time_started: ~T[00:00:00],
        time_finished: ~T[23:59:59],
        date_started: date,
        date_finished: date
      }

      {:ok, duration} = Duration.from_activity(activity)

      assert %Duration{days: 0, hours: 23, minutes: 59} = duration
    end

    test "with multi-day duration" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        time_started: ~T[00:00:00],
        time_finished: ~T[23:59:59],
        date_started: date,
        date_finished: Date.add(date, 1)
      }

      {:ok, duration} = Duration.from_activity(activity)

      assert %Duration{days: 1, hours: 23, minutes: 59} = duration
    end

    test "without start and finish" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        date_started: date,
        date_finished: date
      }

      {:error, duration} = Duration.from_activity(activity)

      assert %Duration{days: 0, hours: 0, minutes: 0} = duration
    end

    test "without start" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        time_finished: ~T[23:59:59],
        date_started: date,
        date_finished: date
      }

      {:error, duration} = Duration.from_activity(activity)

      assert %Duration{days: 0, hours: 0, minutes: 0} = duration
    end

    test "without finish" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        time_started: ~T[00:00:00],
        date_started: date,
        date_finished: date
      }

      {:error, duration} = Duration.from_activity(activity)

      assert %Duration{days: 0, hours: 0, minutes: 0} = duration
    end

    test "without date started" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        time_started: ~T[00:00:00],
        time_finished: ~T[23:59:59],
        date_finished: date
      }

      {:error, duration} = Duration.from_activity(activity)

      assert %Duration{days: 0, hours: 0, minutes: 0} = duration
    end

    test "without date finished" do
      date = Date.utc_today()

      activity = %Activity{
        description: "Test description",
        time_started: ~T[00:00:00],
        time_finished: ~T[23:59:59],
        date_started: date
      }

      {:error, duration} = Duration.from_activity(activity)

      assert %Duration{days: 0, hours: 0, minutes: 0} = duration
    end
  end

  describe "to_string/1" do
    test "days, hours, and minutes" do
      duration = %Duration{days: 2, hours: 23, minutes: 59}

      actual = Duration.to_string(duration)

      assert "2d 23h 59m" == actual
    end

    test "hours and minutes" do
      duration = %Duration{hours: 23, minutes: 59}

      actual = Duration.to_string(duration)

      assert "23h 59m" == actual
    end

    test "minutes" do
      duration = %Duration{minutes: 59}

      actual = Duration.to_string(duration)

      assert "59m" == actual
    end

    test "empty duration" do
      duration = %Duration{}

      actual = Duration.to_string(duration)

      assert "" == actual
    end
  end
end
