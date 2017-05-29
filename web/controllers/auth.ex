defmodule Server.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias Server.Router.Helpers
  alias Server.Repo
  require Logger

  def login(conn, user) do
    Logger.info "logging in: #{inspect user}"
    token = Phoenix.Token.sign(Server.Endpoint, "token", user.id)

    conn
      |> put_session(:user_id, user.id)
      |> put_session(:token, token)
      |> assign(:token, token)
      |> assign(:user, user)
      |> configure_session(renew: true)
  end


  def logout(conn) do
    configure_session(conn, drop: true)
  end

end