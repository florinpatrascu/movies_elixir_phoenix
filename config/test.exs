use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :movies_elixir_phoenix, MoviesElixirPhoenix.Endpoint,
  http: [port: 4001],
  server: false

config :neo4j_sips, Neo4j,
  url: "http://localhost:7373",
  pool_size: 5,
  max_overflow: 2,
  timeout: 10

# Print only warnings and errors during test
config :logger, level: :warn
