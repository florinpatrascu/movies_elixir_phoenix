defmodule MoviesElixirPhoenix.Router do
  use MoviesElixirPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MoviesElixirPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/movies", MoviesElixirPhoenix do
    pipe_through :api

    get "/findByTitleContaining", MovieController, :search_by_title_containing
    get "/findByTitle", MovieController, :search_by_title
    get "/graph", MovieController, :graph
  end
end
