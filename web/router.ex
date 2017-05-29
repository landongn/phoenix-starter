defmodule Server.Router do
  use Server.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Server.SessionPlug, repo: Server.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Server.AdminPlug, repo: Server.Repo
  end

  scope "/", Server do
    pipe_through :browser # Use the default browser stack

    get "/", IndexController, :index

    get "/signup", IndexController, :signup
    post "/signup", IndexController, :register
    post "/login", IndexController, :login

    # new prototype area for threejs
  end

  scope "/cms", Server do
    pipe_through :authenticated
    resources "/classes", ClassController
    resources "/updates", UpdateController
    resources "/users", UserController
  end
end
