defmodule RecordidWeb.DayActivityLiveTest do
  use RecordidWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import Recordid.ActivitiesFixtures, only: [activity_fixture: 1]

  test "loads all the activities for a given day", %{conn: conn} do
    day = ~D[2023-07-17]

    day_activities = create_activities_for_day(day, 2)

    other_activities =
      day
      |> Date.add(-1)
      |> create_activities_for_day(3)

    {:ok, _live_view, html} = live(conn, ~p"/days/#{Date.to_string(day)}")

    for activity <- day_activities do
      assert html =~ activity.description
    end

    for activity <- other_activities do
      refute html =~ activity.description
    end
  end

  test "creating a new activity directly", %{conn: conn} do
    day = ~D[2023-03-15]
    description = "New test activity"

    {:ok, live_view, _html} = live(conn, ~p"/days/#{Date.to_string(day)}/activities/new")

    live_view
    |> form("#activity-form", activity: %{"description" => description})
    |> render_submit()

    assert_patch(live_view, ~p"/days/#{Date.to_string(day)}")

    html =
      live_view
      |> render()

    assert html =~ "Activity created successfully"
    assert html =~ description
  end

  test "editing an activity", %{conn: conn} do
    day = ~D[2023-03-15]
    new_description = "A new test activity"

    activity =
      activity_fixture(
        description: "Test activity to edit",
        time_started: ~T[00:01:00],
        time_finished: Time.add(~T[00:01:00], 25, :minute),
        date_started: day,
        date_finished: day
      )

    {:ok, live_view, _html} =
      live(conn, ~p"/days/#{Date.to_string(day)}/activities/#{activity.id}/edit")

    live_view
    |> form("#activity-form", activity: %{"description" => new_description})
    |> render_submit()

    assert_patch(live_view, ~p"/days/#{Date.to_string(day)}")

    html =
      live_view
      |> render()

    assert html =~ new_description
  end

  test "starting an activity", %{conn: conn} do
    day = ~D[2023-03-15]

    {:ok, live_view, html} = live(conn, ~p"/days/#{Date.to_string(day)}")

    live_view
    |> element("#start-activity")
    |> render_click()

    assert_patch(live_view, ~p"/days/#{Date.to_string(day)}")

    html = live_view |> render()

    assert html =~ ~r/[0-2]\d:[0-5]\d-/
  end

  defp create_activities_for_day(day, count \\ 0) do
    for n <- 0..count do
      activity_fixture(
        description: "Test activity #{n} for day #{day}",
        time_started: ~T[00:01:00],
        time_finished: Time.add(~T[00:01:00], 25, :minute),
        date_started: day,
        date_finished: day
      )
    end
  end
end
