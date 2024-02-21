defmodule Recordid.Repo.Migrations.AddTimeZoneToAccountsUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :time_zone, :string, null: true
    end
  end
end
