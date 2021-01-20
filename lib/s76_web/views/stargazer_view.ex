defmodule S76Web.StargazerView do
  use S76Web, :view

  def render("stargazer.json", %{stargazer: stargazer}) do
    %{
      id: stargazer.id,
      username: stargazer.username,
      inserted_at: stargazer.inserted_at
    }
  end
end
