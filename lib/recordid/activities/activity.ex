defmodule Recordid.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Recordid.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    field :description, :string
    field :raw_content, :string
    field :date_started, :date
    field :date_finished, :date
    field :time_started, :time
    field :time_finished, :time
    belongs_to :user, User

    timestamps()
  end

  @permitted_attrs ~w(description raw_content date_started date_finished time_started time_finished user_id)a

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @permitted_attrs)
    |> validate_required(:user_id)
    |> default_to_today(:date_started)
    |> default_to_today(:date_finished)
  end

  defp default_to_today(changeset, field) when field in [:date_started, :date_finished] do
    case get_field(changeset, field) do
      nil -> put_change(changeset, field, build_default_date(changeset))
      _ -> changeset
    end
  end

  # TODO(lancejjohnson): Revisit. Need to account for time zones.
  defp build_default_date(_changeset) do
    Date.utc_today()
  end
end
