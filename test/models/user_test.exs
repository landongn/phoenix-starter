defmodule Server.UserTest do
  use Server.ModelCase

  alias Server.User

  @valid_attrs %{banned: true, email_address: "some content", muted: true, password_hash: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
