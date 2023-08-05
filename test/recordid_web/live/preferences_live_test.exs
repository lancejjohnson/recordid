defmodule RecordidWeb.Live.PreferencesLiveTest do
  use RecordidWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Recordid.AccountsFixtures

  describe "preferences page" do
    test "renders preferences page", %{conn: conn} do
      {:ok, _live_view, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/preferences")

      assert html =~ "Change time zone"
    end
  end
end
