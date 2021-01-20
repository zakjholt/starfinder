defmodule S76Web.RepositoryController do
  use S76Web, :controller

  alias S76.Github
  alias S76.Github.Repository

  action_fallback S76Web.FallbackController

  def index(conn, _params) do
    repositories = Github.list_repositories()
    render(conn, "index.json", repositories: repositories)
  end

  def create(conn, %{"repository" => repository_params}) do
    with {:ok, %Repository{} = repository} <- Github.create_repository(repository_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.repository_path(conn, :show, repository))
      |> render("show.json", repository: repository)
    end
  end

  def show_stargazers(conn, %{"start_date" => start_date, "id" => id}) do
    # TODO: make date parsing much better. Or at least handle errors
    start_d = NaiveDateTime.from_iso8601!("#{start_date}T00:00:00,000Z")

    {repository, old_stargazers, new_stargazers} =
      Github.get_repository_with_grouped_stargazers(id, start_d)

    render(conn, "repository_with_stargazer_distribution.json",
      repository: repository,
      old_stargazers: old_stargazers,
      new_stargazers: new_stargazers
    )
  end

  def show_stargazers(conn, %{"id" => id}) do
    repository = Github.get_repository!(id) |> S76.Repo.preload(:stargazers)
    render(conn, "repository_with_stargazers.json", repository: repository)
  end

  def show(conn, %{"id" => id}) do
    repository = Github.get_repository!(id)
    render(conn, "show.json", repository: repository)
  end

  def update(conn, %{"id" => id, "repository" => repository_params}) do
    repository = Github.get_repository!(id)

    with {:ok, %Repository{} = repository} <-
           Github.update_repository(repository, repository_params) do
      render(conn, "show.json", repository: repository)
    end
  end

  def delete(conn, %{"id" => id}) do
    repository = Github.get_repository!(id)

    with {:ok, %Repository{}} <- Github.delete_repository(repository) do
      send_resp(conn, :no_content, "")
    end
  end
end
