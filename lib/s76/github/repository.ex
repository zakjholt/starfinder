defmodule S76.Github.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  alias S76.Github.Stargazer

  schema "repositories" do
    field :name, :string
    field :owner, :string

    has_many :stargazers, Stargazer

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:owner, :name])
    |> validate_required([:owner, :name])
    |> unique_constraint(:owner_name, name: :unique_repository)
  end
end
