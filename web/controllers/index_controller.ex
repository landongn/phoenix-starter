defmodule Server.IndexController do
  use Server.Web, :controller
  alias Server.Router.Helpers
  alias Server.User
  alias Server.Repo

  alias Server.Update

  require Logger

  def index(conn, _params) do
    render conn, "index.html", %{}
  end

  def login_form(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render conn, "login.html", changeset: changeset
  end

  def game(conn, _params) do
    user_id = get_session(conn, :user_id)
    if user_id == nil do
      conn
      |> Server.Auth.logout
      |> put_flash(:info, "you need to login")
      |> redirect(to: index_path(conn, :login_form))
      |> halt
    end
    render conn, "game.html"
  end

  def play(conn, _params) do
    user_id = get_session(conn, :user_id)
    if user_id == nil do

      conn
      |> Server.Auth.logout
      |> put_flash(:info, "you need to log in to play")
      |> redirect(to: index_path(conn, :login_form))
      |> halt
    end
    render conn, "play.html"
  end

  def signup(conn, _) do
    changeset = User.new_account(%User{}, %{})
    render conn, "signup.html", changeset: changeset
  end

  def register(conn, %{"user" => %{"email" => email, "password" => password, "name" => name}}) do
    Logger.info "#{email}"
    case Server.Repo.get_by User, email: email do
      nil ->
        changeset = User.new_account(%User{}, %{
          email: email, name: name, password: Comeonin.Bcrypt.hashpwsalt(password)
        })
        case Repo.insert(changeset) do
          {:ok, user} ->

            Logger.info "user registered: #{user.email}"
            conn
            |> Server.Auth.login(user)
            |> redirect(to: index_path(conn, :play))
            |> halt
          {:error, changeset} ->
            Logger.info "user failed: #{changeset.changes.email}"
            conn
            |> put_flash(:error, "Cant create an account. Try a different email address")
            render(conn, "signup.html", changeset: changeset)
        end
      existing ->
        Logger.info "already exists: #{email}"
        conn |> put_flash(:error, "email already exists.  Did you want to login instead?")
        render(conn, "signup.html", changeset: User.new_account(%User{}, %{}))
    end
    render(conn, "signup.html", changeset: User.new_account(%User{}, %{}))
  end

  def login(conn, %{"user" => user_params}) do
    Logger.info "attemping to login as #{inspect user_params}"

    case Repo.get_by User, email: user_params["email"] do
      player ->
        case Comeonin.Bcrypt.checkpw(user_params["password"], player.password) do
          true ->
            Logger.info "Password match found"
            conn
            |> Server.Auth.login(player)
            |> redirect(to: "/")
            |> halt
          false ->
            Logger.info "unable to match passwords for the user."
            conn |> put_flash(:error, "unable to log you in. no matching user for that username or password")
            render conn, "login.html", changeset: User.changeset(%User{}, %{})
        end
      nil ->
        Logger.info "unable to find a player, or player was nil."
        conn |> put_flash(:info, "unable to log the user in, no record found")
        render conn, "login.html", changeset: User.changeset(%User{}, %{})
      end
    render conn, "login.html", changeset: User.changeset(%User{}, %{})
  end

  def logout(conn, _) do
    Server.Auth.logout(conn)
    conn.redirect(to: Helpers.index_path(conn, :index))
    conn |> halt
  end
end
