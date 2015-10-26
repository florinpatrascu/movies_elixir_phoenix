defmodule MoviesElixirPhoenix.Utils do

  def movie_and_roles(nodes, relationships, title) do
    movie = List.first nodes |> Enum.filter &(Map.has_key?(&1, :title) && &1.title == title)
    roles = Enum.filter(relationships, &(&1.end == movie.id))
    persons = Enum.map roles, &( Map.merge(
      List.first(find_person_by_id(nodes, &1.start)), Dict.take(&1, [:roles, :type]) ))

    # meh
    Map.merge movie, %{crew: persons}
  end


  def nodes_and_relationships(graph) do
    nodes =  Enum.map(graph, &(parse_nodes(&1))) |> Enum.filter &(&1 != nil)
    rels = Enum.map(graph, &(parse_relationships(&1))) |> Enum.filter &(&1 != nil && &1 != [])
    {List.flatten(nodes), List.flatten(rels)} # todo: refactor me
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

  defp find_person_by_id(nodes, id) do
    nodes
    |> Enum.map(&(if &1.id == id do %{id: &1.id, name: &1.name} end))
    |> Enum.filter(&(&1 != nil))
    |> List.flatten
  end
end
