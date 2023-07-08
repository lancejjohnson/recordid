defmodule Recordid.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :text
      add :raw_content, :text
      add :date_started, :date
      add :date_finished, :date
      add :time_started, :time
      add :time_finished, :time

      timestamps()
    end
  end
end
