defmodule MoviesElixirPhoenix.MovieController do
  use MoviesElixirPhoenix.Web, :controller

  alias MoviesElixirPhoenix.Movie
  alias Neo4j.Sips, as: Neo4j

  def search_by_title(conn, %{"title" => title}) do
    cypher = """
      MATCH (n:Movie {title: \"#{title}\"})
         WITH n MATCH p=(n)-[*0..1]-(m)
         RETURN p, ID(n) as id
    """

    data = Neo4j.query!(Neo4j.conn(%{resultDataContents: ["row", "graph"]}), cypher)
    {nodes, relationships} = data[:graph] |> nodes_and_relationships

    render(conn, "search_by_title.json",
        movie: movie_and_roles(nodes, relationships, title))
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

  # private stuff, playground mostly
  # ================================

  defp parse_nodes(graph) do
    nodes = graph["nodes"]
    |> Enum.map(fn(n) ->
        model = %{id: String.to_integer(n["id"]), labels: n["labels"]}
        func = &Map.merge(model, &1)
        n["properties"]
        |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
        |> Enum.into(%{})
        |> func.()
       end)
  end

  defp parse_relationships(graph) do
    rels = graph["relationships"]
    |> Enum.map(fn(r) ->
        model = %{id: String.to_integer(r["id"]),
                  start: String.to_integer(r["startNode"]),
                  end: String.to_integer(r["endNode"]),
                  type: r["type"]}
        func = &Map.merge(model, &1)
        r["properties"]
        |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
        |> Enum.into(%{})
        |> func.()
      end)
  end

  defp nodes_and_relationships(graph) do
    nodes =  Enum.map(graph, &(parse_nodes(&1))) |> Enum.filter &(&1 != nil)
    rels = Enum.map(graph, &(parse_relationships(&1))) |> Enum.filter &(&1 != nil && &1 != [])
    {List.flatten(nodes), List.flatten(rels)} # todo: refactor me
  end

  defp find_person_by_id(nodes, id) do
    nodes
    |> Enum.map(&(if &1.id == id do %{id: &1.id, name: &1.name} end))
    |> Enum.filter(&(&1 != nil))
    |> List.flatten
  end

  defp movie_and_roles(nodes, relationships, title) do
    movie = List.first nodes |> Enum.filter &(Map.has_key?(&1, :title) && &1.title == title)
    roles = Enum.filter(relationships, &(&1.end == movie.id))
    persons = Enum.map roles, &( Map.merge(
      List.first(find_person_by_id(nodes, &1.start)), Dict.take(&1, [:roles, :type]) ))

    # meh
    Map.merge movie, %{crew: persons}
  end
end
