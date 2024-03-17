defmodule Recordid.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Recordid.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    field :description, :string
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime

    belongs_to :user, User

    timestamps()
  end

  @permitted_attrs ~w(user_id description started_at finished_at)a

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @permitted_attrs)
    |> validate_required(:user_id)
    |> foreign_key_constraint(:user_id)
  end
end
