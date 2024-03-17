defmodule Recordid.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :text
      add :started_at, :utc_datetime
      add :finished_at, :utc_datetime

      timestamps()
    end
  end
end
