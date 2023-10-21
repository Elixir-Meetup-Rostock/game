defmodule Game.Repo.Migrations.UserAccountUpdate do
  use Ecto.Migration

  def change do
    alter table(:users) do
      # add unique username
      add :username, :string, null: false
    end

    create unique_index(:users, [:username])
  end
end
