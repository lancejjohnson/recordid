defmodule Recordid.Accounts.PreferencesTest do
  use Recordid.DataCase, async: true

  alias Recordid.Accounts.Preferences

  @invalid_time_zone "America/Europa"

  test "timezone must be a valid timezone" do
    changeset = Preferences.changeset(%Preferences{}, %{"time_zone" => @invalid_time_zone})

    refute changeset.valid?
    assert "invalid time zone" in errors_on(changeset).time_zone
  end
end
