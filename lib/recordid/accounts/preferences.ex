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
    |> validate_required(@required)
    |> validate_time_zone()
  end

  defp validate_time_zone(cset) do
    # Tzdata.zone_exists?(time_zone)
    # case get_field(cset, :time_zone) do
    # end
    # with {:ok, _times} <- get_changing_time_field_keys(cset),
    #      time_zone when is_binary(time_zone) <- get_field(cset, :time_zone),
    #      true <- Tzdata.zone_exists?(time_zone) do
    #   cset
    # else
    #   {:no_changing_times, _} -> cset
    #   nil -> add_error(cset, :time_zone, "can't be blank")
    #   false -> add_error(cset, :time_zone, "invalid time_zone")
    # end
  end
end
