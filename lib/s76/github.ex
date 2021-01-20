defmodule S76.Github do
  @moduledoc """
  The Github context.
  """

  import Ecto.Query, warn: false
  alias S76.Repo

  alias S76.Github.Repository
  alias S76.Github.Stargazer

  @doc """
  Returns the list of repositories.

  ## Examples

      iex> list_repositories()
      [%Repository{}, ...]

  """
  def list_repositories do
    Repo.all(Repository)
  end

  @doc """
  Gets a single repository.

  Raises `Ecto.NoResultsError` if the Repository does not exist.

  ## Examples

      iex> get_repository!(123)
      %Repository{}

      iex> get_repository!(456)
      ** (Ecto.NoResultsError)

  """
  def get_repository!(id), do: Repo.get!(Repository, id)

  def get_repository_with_grouped_stargazers(id, start_date) do
    repository = get_repository!(id)

    # TODO: optimize these into one group_by query
    old_stargazers =
      Repo.all(from s in Stargazer, where: s.inserted_at < ^start_date and s.repository_id == ^id)

    new_stargazers =
      Repo.all(
        from s in Stargazer,
          where: s.inserted_at >= ^start_date and s.repository_id == ^id
      )

    {repository, old_stargazers, new_stargazers}
  end

  @doc """
  Creates a repository.

  ## Examples

      iex> create_repository(%{field: value})
      {:ok, %Repository{}}

      iex> create_repository(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_repository(attrs \\ %{}) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  def create_stargazer(attrs \\ %{}) do
    %Stargazer{}
    |> Stargazer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a repository.

  ## Examples

      iex> update_repository(repository, %{field: new_value})
      {:ok, %Repository{}}

      iex> update_repository(repository, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_repository(%Repository{} = repository, attrs) do
    repository
    |> Repository.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a repository.

  ## Examples

      iex> delete_repository(repository)
      {:ok, %Repository{}}

      iex> delete_repository(repository)
      {:error, %Ecto.Changeset{}}

  """
  def delete_repository(%Repository{} = repository) do
    Repo.delete(repository)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking repository changes.

  ## Examples

      iex> change_repository(repository)
      %Ecto.Changeset{data: %Repository{}}

  """
  def change_repository(%Repository{} = repository, attrs \\ %{}) do
    Repository.changeset(repository, attrs)
  end
end
