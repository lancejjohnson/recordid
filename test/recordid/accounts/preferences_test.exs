defmodule Recordid.Accounts.PreferencesTest do
  use Recordid.DataCase, async: true

  alias Recordid.Accounts.Preferences

  @invalid_time_zone "'merica/Europa"

  test "time zone is required" do
    changeset = Preferences.changeset(%Preferences{}, %{})

    assert "can't be blank" in errors_on(changeset).time_zone
  end

  test "time zone must be a valid timezone" do
    changeset = Preferences.changeset(%Preferences{}, %{"time_zone" => @invalid_time_zone})

    assert "invalid" in errors_on(changeset).time_zone
  end
end
