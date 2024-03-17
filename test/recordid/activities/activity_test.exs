defmodule Recordid.Activities.ActivityTest do
  use Recordid.DataCase, async: true

  alias Recordid.Activities.Activity

  test "user is required" do
    changeset = Activity.changeset(%Activity{}, %{})

    refute changeset.valid?
    assert "can't be blank" in errors_on(changeset).user_id
  end

  test "user must exist" do
    {:error, changeset} =
      %Activity{}
      |> Activity.changeset(%{user_id: Ecto.UUID.generate()})
      |> Repo.insert()

    refute changeset.valid?
    assert "does not exist" in errors_on(changeset).user_id
  end
end
