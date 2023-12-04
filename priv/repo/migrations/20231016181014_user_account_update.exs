defmodule Game.Repo.Migrations.UserAccountUpdate do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :username, :string
    end

    flush()
    Game.Repo.update_all("users", set: [username: "user#{System.unique_integer()}"])

    alter table(:users) do
      modify :username, :string, null: false
    end

    create unique_index(:users, [:username])
  end

  def down do
    drop index(:users, [:username])

    alter table(:users) do
      remove :username
    end
  end
end
