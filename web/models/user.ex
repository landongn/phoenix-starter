defmodule Server.User do
  use Server.Web, :model

  schema "users" do
    field :username, :string
    field :email_address, :string
    field :password_hash, :string
    field :banned, :boolean, default: false
    field :muted, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email_address, :password_hash, :banned, :muted])
    |> validate_required([:username, :email_address, :password_hash, :banned, :muted])
  end

  def new_account(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password, :email])
    |> validate_required([:email, :password, :name])
  end
end
