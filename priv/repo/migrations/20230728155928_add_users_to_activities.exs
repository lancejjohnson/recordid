defmodule Recordid.Repo.Migrations.AddUsersToActivities do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :user_id, references(:users, type: :uuid)
    end
  end
end
