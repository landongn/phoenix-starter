defmodule Server.SessionPlug do
  @behaviour Plug
  import Plug.Conn

  require Logger

  def init(opts), do: opts

  def call(conn, _) do
    user = get_session(conn, :user_id)
    if user do
        conn
        |> assign(:token, Phoenix.Token.sign(Server.Endpoint, "token", user))
        |> assign(:user_id, user)
    else
        conn
    end
  end
end