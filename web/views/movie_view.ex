defmodule MoviesElixirPhoenix.MovieView do
  use MoviesElixirPhoenix.Web, :view

  def render("index.json", %{movies: movies}) do
    %{data: render_many(movies, MoviesElixirPhoenix.MovieView, "movie.json")}
  end

  def render("search_by_title_containing.json", %{movies: movies}) do
    %{ movies: Enum.map(movies, &(Map.get(&1, "movie")))}
  end

  # def render("show.json", %{movie: movie}) do
  #   %{data: render_one(movie, MoviesElixirPhoenix.MovieView, "movie.json")}
  # end

  def render("search_by_title.json", %{movie: movie}) do
    movie
  end

  # todo: finish my implementation
  def render("graph.json", %{graph: graph}) do
    graph
  end
end
