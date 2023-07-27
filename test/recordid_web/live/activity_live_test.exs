defmodule RecordidWeb.ActivityLiveTest do
  use RecordidWeb.ConnCase

  import Phoenix.LiveViewTest
  import Recordid.ActivitiesFixtures

  @create_attrs %{}
  @update_attrs %{}

  defp create_activity(_) do
    activity = activity_fixture()
    %{activity: activity}
  end

  setup :register_and_log_in_user

  describe "Creating an activity" do
    test "without any data", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      html =
        index_live
        |> open_new_activity_form!()
        |> submit_new_activity!(%{})
        |> render()

      assert html =~ "Activity created successfully"
    end

    test "with just a description", %{conn: conn} do
      description = "Did some stuff"
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      html =
        index_live
        |> open_new_activity_form!()
        |> submit_new_activity!(%{"description" => description})
        |> render()

      assert html =~ "Activity created successfully"
      assert html =~ description
    end

    test "with a start time", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      html =
        index_live
        |> open_new_activity_form!()
        |> submit_new_activity!(%{"time_started" => "00:01"})
        |> render()

      assert html =~ "Activity created successfully"
      assert html =~ "00:01"
    end

    test "with a finish time", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      html =
        index_live
        |> open_new_activity_form!()
        |> submit_new_activity!(%{"time_finished" => "23:59"})
        |> render()

      assert html =~ "Activity created successfully"
      assert html =~ "23:59"
    end
  end

  defp open_new_activity_form!(live_view) do
    assert live_view
           |> element("a", "New Activity")
           |> render_click() =~ "New Activity"

    assert_patch(live_view, ~p"/activities/new")

    live_view
  end

  defp submit_new_activity!(live_view, attrs) do
    assert live_view
           |> form("#activity-form", activity: attrs)
           |> render_submit()

    assert_patch(live_view, ~p"/activities")

    live_view
  end

  describe "Index" do
    setup [:create_activity]

    test "lists all activities", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/activities")

      assert html =~ "Listing Activities"
    end

    test "saves new activity", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert index_live |> element("a", "New Activity") |> render_click() =~
               "New Activity"

      assert_patch(index_live, ~p"/activities/new")

      # assert index_live
      #        |> form("#activity-form", activity: @invalid_attrs)
      #        |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#activity-form", activity: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/activities")

      html = render(index_live)
      assert html =~ "Activity created successfully"
    end

    test "updates activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert index_live |> element("#activities-#{activity.id} a", "Edit") |> render_click() =~
               "Edit Activity"

      assert_patch(index_live, ~p"/activities/#{activity}/edit")

      # assert index_live
      #        |> form("#activity-form", activity: @invalid_attrs)
      #        |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#activity-form", activity: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/activities")

      html = render(index_live)
      assert html =~ "Activity updated successfully"
    end

    test "deletes activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, ~p"/activities")

      assert index_live |> element("#activities-#{activity.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#activities-#{activity.id}")
    end
  end

  describe "Show" do
    setup [:create_activity]

    test "displays activity", %{conn: conn, activity: activity} do
      {:ok, _show_live, html} = live(conn, ~p"/activities/#{activity}")

      assert html =~ "Show Activity"
    end

    test "updates activity within modal", %{conn: conn, activity: activity} do
      {:ok, show_live, _html} = live(conn, ~p"/activities/#{activity}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Activity"

      assert_patch(show_live, ~p"/activities/#{activity}/show/edit")

      # assert show_live
      #        |> form("#activity-form", activity: @invalid_attrs)
      #        |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#activity-form", activity: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/activities/#{activity}")

      html = render(show_live)
      assert html =~ "Activity updated successfully"
    end
  end
end
