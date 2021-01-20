defmodule S76Web.RepositoryView do
  use S76Web, :view
  alias S76Web.RepositoryView

  def render("index.json", %{repositories: repositories}) do
    %{data: render_many(repositories, RepositoryView, "repository.json")}
  end

  def render("show.json", %{repository: repository}) do
    %{data: render_one(repository, RepositoryView, "repository.json")}
  end

  def render("repository.json", %{repository: repository}) do
    %{
      id: repository.id,
      owner: repository.owner,
      name: repository.name
    }
  end

  def render("repository_with_stargazers.json", %{repository: repository}) do
    %{
      id: repository.id,
      owner: repository.owner,
      name: repository.name,
      stargazers: render_many(repository.stargazers, S76Web.StargazerView, "stargazer.json")
    }
  end

  def render("repository_with_stargazer_distribution.json", %{
        repository: repository,
        old_stargazers: old_stargazers,
        new_stargazers: new_stargazers
      }) do
    %{
      id: repository.id,
      owner: repository.owner,
      name: repository.name,
      old_stargazers: render_many(old_stargazers, S76Web.StargazerView, "stargazer.json"),
      new_stargazers: render_many(new_stargazers, S76Web.StargazerView, "stargazer.json")
    }
  end
end
