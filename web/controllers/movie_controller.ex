defmodule MoviesElixirPhoenix.MovieController do
  use MoviesElixirPhoenix.Web, :controller

  alias MoviesElixirPhoenix.Movie
  alias MoviesElixirPhoenix.Utils
  alias Neo4j.Sips, as: Neo4j

  def search_by_title(conn, %{"title" => title}) do
    cypher = """
      MATCH (n:Movie {title: \"#{title}\"})
         WITH n MATCH p=(n)-[*0..1]-(m)
         RETURN p, ID(n) as id
    """

    data = Neo4j.query!(Neo4j.conn(%{resultDataContents: ["row", "graph"]}), cypher)
    {nodes, relationships} = data[:graph] |> Utils.nodes_and_relationships

    render(conn, "search_by_title.json",
        movie: Utils.movie_and_roles(nodes, relationships, title))
  end

  def search_by_title_containing(conn, %{"title" => title}) do
    cypher="""
      MATCH (m:Movie) WHERE m.title =~ (\"(?i).*#{title}.*\")
      RETURN m as movie
    """

    movies=Neo4j.query!(Neo4j.conn, cypher)
    render(conn, "search_by_title_containing.json", movies: movies)
  end

  # todo: add a View for this
  def graph(conn, %{"limit" => limit}) do
    cypher="""
      MATCH (m:Movie)<-[:ACTED_IN]-(a:Person)
      RETURN m.title as movie, collect(a.name) as cast
      LIMIT #{limit}
    """

    graph=Neo4j.query!(Neo4j.conn, cypher)
    render(conn, "search_by_title_containing.json", graph: graph)
  end

end
