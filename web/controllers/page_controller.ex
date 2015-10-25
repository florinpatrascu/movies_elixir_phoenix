defmodule MoviesElixirPhoenix.PageController do
  use MoviesElixirPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
