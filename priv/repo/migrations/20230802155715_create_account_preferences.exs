defmodule Recordid.Repo.Migrations.CreateAccountPreferences do
  use Ecto.Migration

  def change do
    create table(:account_preferences, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :time_zone, :string

      timestamps()
    end
  end
end
