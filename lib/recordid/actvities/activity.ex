defmodule Recordid.Actvities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    field :description, :string
    field :raw_content, :string
    field :date_started, :date
    field :date_finished, :date
    field :time_started, :time
    field :time_finished, :time

    timestamps()
  end

  @permitted_attrs ~w(description raw_content date_started date_finished time_started time_finished)a

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @permitted_attrs)
  end
end
