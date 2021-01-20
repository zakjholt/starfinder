defmodule S76.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :owner, :string
      add :name, :string

      timestamps()
    end

    create unique_index(:repositories, [:owner, :name], name: :unique_repository)
  end
end
