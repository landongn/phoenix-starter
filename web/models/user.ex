defmodule Server.User do
  use Server.Web, :model

  schema "users" do
    field :username, :string
    field :email_address, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :banned, :boolean, default: false
    field :muted, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email_address, :password_hash])
    |> validate_required([:username, :email_address, :password_hash])
  end
end
