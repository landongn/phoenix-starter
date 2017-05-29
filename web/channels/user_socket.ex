defmodule Server.UserSocket do
  use Phoenix.Socket

  ## Channels


  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #[]
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket) do

    case Phoenix.Token.verify(Server.Endpoint, "token", params["token"]) do
      {:ok, valid_id} -> {:ok, assign(socket, :player_id, valid_id)}
      {:error, :invalid} -> :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Server.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket) do
    "users_socket:#{socket.assigns.player_id}"
  end



end
