defmodule Recordid.ActivitiesTest do
  use Recordid.DataCase

  alias Recordid.Activities

  describe "creating an activity" do
    test "defaults to today when start date is not included" do
      {:ok, activity} = Activities.create_activity(%{})
      assert activity.date_started == Date.utc_today()
    end

    test "defaults to today when finish date is not included" do
      {:ok, activity} = Activities.create_activity(%{})
      assert activity.date_finished == Date.utc_today()
    end
  end

  describe "activities" do
    alias Recordid.Activities.Activity

    import Recordid.ActivitiesFixtures

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      valid_attrs = %{}

      assert {:ok, %Activity{}} = Activities.create_activity(valid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      update_attrs = %{}

      assert {:ok, %Activity{}} = Activities.update_activity(activity, update_attrs)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end
end
