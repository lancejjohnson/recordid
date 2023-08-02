defmodule Recordid.Accounts.Preferences do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account_preferences" do
    field :timezone, :string

    timestamps()
  end

  @doc false
  def changeset(preferences, attrs) do
    preferences
    |> cast(attrs, [:timezone])
    |> validate_required([:timezone])
  end
end
