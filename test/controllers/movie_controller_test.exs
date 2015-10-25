defmodule MoviesElixirPhoenix.MovieControllerTest do
  use MoviesElixirPhoenix.ConnCase

  alias MoviesElixirPhoenix.Movie
  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

end
