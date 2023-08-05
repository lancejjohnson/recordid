defmodule Recordid.Accounts.PreferencesTest do
  use Recordid.DataCase, async: true

  alias Recordid.Accounts.Preferences

  @invalid_timezone "America/Europa"

  test "timezone must be a valid timezone" do
    changeset = Preferences.changeset(%Preferences{}, %{"timezone" => @invalid_timezone})

    refute changeset.valid?
    assert "invalid timezone" in errors_on(changeset).timezone
  end
end
