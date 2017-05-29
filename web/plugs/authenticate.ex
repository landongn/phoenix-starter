defmodule Server.AdminPlug do
  @behaviour Plug
  import Plug.Conn

  import Phoenix.Controller

  alias Server.Repo
  alias Server.User
  require Logger

  def init(opts), do: opts

  def call(conn, _) do
    user = get_session(conn, :user_id)
    if user do
      p = Repo.get(User, user)
      if p.is_admin === true do
        conn
      else
        conn |> Phoenix.Controller.redirect(to: "/login")
      end
    else
      conn |> Phoenix.Controller.redirect(to: "/login")
    end
  end
end