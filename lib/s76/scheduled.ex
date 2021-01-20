defmodule S76.Scheduled do
  use Quantum, otp_app: :your_app
  alias S76.Github

  def backfill_stargazers() do
    Github.list_repositories()
    |> Enum.each(&backfill_repo_stargazers/1)
  end

  defp backfill_repo_stargazers(%Github.Repository{id: id, name: name, owner: owner}) do
    stargazer_url = "https://api.github.com/repos/#{owner}/#{name}/stargazers"

    HTTPoison.get!(stargazer_url).body
    |> Jason.decode!()
    |> create_repo_stargazers(id)
  end

  defp create_repo_stargazers(stargazers, repo_id) do
    # TODO: Implement a bulk creation util
    stargazers
    |> Enum.each(fn attrs ->
      Github.create_stargazer(%{
        github_id: attrs["id"],
        username: attrs["login"],
        repository_id: repo_id
      })
    end)
  end
end
