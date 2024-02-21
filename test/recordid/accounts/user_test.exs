defmodule Recordid.Accounts.UserTest do
  use Recordid.DataCase, async: true

  alias Recordid.Accounts.User

  describe "time_zone_changeset/2" do
    test "provides a changeset for the user's time zone" do
      changeset = User.time_zone_changeset(%User{}, %{"time_zone" => random_valid_tz()})

      assert %Ecto.Changeset{valid?: true} = changeset
    end

    test "time zone must exist" do
      changeset = User.time_zone_changeset(%User{}, %{"time_zone" => invalid_tz()})

      assert %Ecto.Changeset{valid?: false} = changeset
      assert "does not exist" in errors_on(changeset).time_zone
    end
  end

  defp invalid_tz() do
    "Mordor/East"
  end

  defp random_valid_tz() do
    Enum.random(Tzdata.canonical_zone_list())
  end
end
