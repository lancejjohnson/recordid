defmodule Recordid.Accounts.Preferences do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account_preferences" do
    field :time_zone, :string

    timestamps()
  end

  @cast [:time_zone]
  @require [:time_zone]

  @doc false
  def changeset(preferences, attrs) do
    preferences
    |> cast(attrs, @cast)
    |> validate_required(@require)
    |> validate_change(:time_zone, &validate_time_zone/2)
  end

  defp validate_time_zone(:time_zone, time_zone) do
    if Tzdata.zone_exists?(time_zone) do
      []
    else
      [time_zone: "invalid"]
    end
  end
end
