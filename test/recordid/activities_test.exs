defmodule Recordid.ActivitiesTest do
  use Recordid.DataCase

  alias Recordid.Activities

  setup do
    user = Recordid.AccountsFixtures.user_fixture()
    {:ok, %{user: user}}
  end

  describe "creating an activity" do
    test "defaults to today when start date is not included", %{user: user} do
      {:ok, activity} = Activities.create_activity(%{user_id: user.id})
      assert activity.date_started == Date.utc_today()
    end

    test "defaults to today when finish date is not included", %{user: user} do
      {:ok, activity} = Activities.create_activity(%{user_id: user.id})
      assert activity.date_finished == Date.utc_today()
    end
  end

  describe "activities" do
    alias Recordid.Activities.Activity

    import Recordid.ActivitiesFixtures

    setup do
      user = Recordid.AccountsFixtures.user_fixture()
      {:ok, %{user: user}}
    end

    test "list_activities/1 returns all activities", %{user: user} do
      activity = activity_fixture(%{user_id: user.id})
      assert Activities.list_activities(user) == [activity]
    end

    test "list_activities_for_date/1 returns all activities for a given date", %{user: user} do
      today = Date.utc_today()

      for n <- 0..3 do
        day = Date.add(today, n * -1)

        for m <- 0..Enum.random(1..3) do
          time_started = Time.from_iso8601!("0#{m}:#{n}#{m + 1}:00")

          activity_fixture(
            user_id: user.id,
            date_started: day,
            date_finished: day,
            time_started: time_started,
            time_finished: Time.add(time_started, m * Enum.random(0..9))
          )
        end
      end

      activities = Activities.list_activities_for_date(user, today)

      for activity <- activities do
        assert today == activity.date_started
      end

      two_days_ago = Date.add(today, -2)
      activities = Activities.list_activities_for_date(user, two_days_ago)

      for activity <- activities do
        assert two_days_ago == activity.date_started
      end
    end

    test "get_activity!/1 returns the activity with given id", %{user: user} do
      activity = activity_fixture(%{user_id: user.id})
      assert Activities.get_activity!(user, activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity", %{user: user} do
      valid_attrs = %{user_id: user.id}

      assert {:ok, %Activity{}} = Activities.create_activity(valid_attrs)
    end

    test "update_activity/2 with valid data updates the activity", %{user: user} do
      activity = activity_fixture(%{user_id: user.id})
      update_attrs = %{}

      assert {:ok, %Activity{}} = Activities.update_activity(activity, update_attrs)
    end

    test "delete_activity/1 deletes the activity", %{user: user} do
      activity = activity_fixture(%{user_id: user.id})
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(user, activity.id) end
    end

    test "change_activity/1 returns a activity changeset", %{user: user} do
      activity = activity_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end
end
