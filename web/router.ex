defmodule BitchSlack.Router do
  use BitchSlack.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BitchSlack do
    pipe_through :browser

    post "/slap", SlapController, :slap
  end

  # Other scopes may use custom stacks.
  # scope "/api", BitchSlack do
  #   pipe_through :api
  # end
end
