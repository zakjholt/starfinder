defmodule S76.Repo.Migrations.CreateStargazers do
  use Ecto.Migration

  def change do
    create table(:stargazers) do
      add :username, :string
      add :github_id, :integer
      add :repository_id, references(:repositories, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:stargazers, [:repository_id, :github_id], name: :unique_stargazer)
  end
end
