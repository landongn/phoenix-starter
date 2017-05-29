defmodule Server.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email_address, :string
      add :password_hash, :string
      add :banned, :boolean, default: false, null: false
      add :muted, :boolean, default: false, null: false

      timestamps()
    end

  end
end
