defmodule RetryApiWeb.Router do
  use RetryApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RetryApiWeb do
    pipe_through :api

    resources "/positions", PositionController, except: [:new, :edit]
  end
end
