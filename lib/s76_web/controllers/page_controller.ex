defmodule S76Web.PageController do
  use S76Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
