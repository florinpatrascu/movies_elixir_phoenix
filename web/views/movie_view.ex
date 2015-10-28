defmodule MoviesElixirPhoenix.MovieView do
  use MoviesElixirPhoenix.Web, :view

  def render("search_by_title_containing.json", %{movies: movies}) do
    %{ movies: Enum.map(movies, &(Map.get(&1, "movie")))}
  end

  # def render("show.json", %{movie: movie}) do
  #   %{data: render_one(movie, MoviesElixirPhoenix.MovieView, "movie.json")}
  # end

  def render("search_by_title.json", %{movie: movie}) do
    movie
  end

  def render("graph.json", %{data: data}) do
    %{links: links, nodes: nodes} = data

    t3links = Enum.map(links, fn({s, t}) -> %{source: s, target: t} end)
    t3nodes = Enum.map(nodes, fn(n) ->
        case (n) do
          %{artist: a} -> %{label: "actor", title: a}
          %{movie: m}  -> %{label: "movie", title: m}
        end
      end)

    %{ links: t3links, nodes: t3nodes}
  end
end
