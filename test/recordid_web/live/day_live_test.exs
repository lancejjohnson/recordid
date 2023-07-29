defmodule RecordidWeb.Live.DayLiveTest do
  use RecordidWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import Recordid.ActivitiesFixtures

  setup :register_and_log_in_user

  test "lists all of the days for which you have recordid activities", %{conn: conn, user: user} do
    days = [~D[2023-03-15], ~D[2023-03-15], ~D[2023-01-01], ~D[2022-12-25]]

    for day <- days do
      create_activities(
        user,
        %{
          date_started: day,
          date_finished: day,
          time_started: Time.utc_now(),
          time_finished: Time.utc_now() |> Time.add(25, :minute),
          description: "Test activity for user #{user.id} on day #{Date.to_string(day)}"
        },
        Enum.random(1..3)
      )
    end

    {:ok, live_view, html} = live(conn, ~p"/days")

    for day <- days do
      assert html =~ Date.to_string(day)
      assert has_element?(live_view, "a", Date.to_string(day))
    end
  end

  test "provides access to the day activity view for today", %{conn: conn} do
    {:ok, live_view, _html} = live(conn, ~p"/days")

    assert has_element?(live_view, "a", "Today")
  end
end
