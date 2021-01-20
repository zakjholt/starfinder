defmodule S76.Github.Stargazer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stargazers" do
    field :github_id, :integer
    field :username, :string
    field :repository_id, :id

    timestamps()
  end

  @doc false
  def changeset(stargazer, attrs) do
    stargazer
    |> cast(attrs, [:username, :github_id, :repository_id])
    |> validate_required([:username, :github_id, :repository_id])
    |> unique_constraint(:unique_stargazer, name: :unique_stargazer)
  end
end
