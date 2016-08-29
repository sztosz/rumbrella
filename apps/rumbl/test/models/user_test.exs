defmodule Rumbl.UserTest do
  use Rumbl.ModelCase, async: true

  alias Rumbl.User

  @valid_atrrs %{name: "A User", username: "eve", password: "secret"}
  @invalid_attrs %{}

  test "changeset woith valid attributes" do
    changeset = User.changeset(%User{}, @valid_atrrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset does not accept long usernames" do
    attrs = Map.put(@valid_atrrs, :username, String.duplicate("a", 30))
    assert {:username, "should be at most 20 character(s)"}
      in errors_on(%User{}, attrs)
  end

  test "registration_changeset must be at least 6 chars long" do
    attrs = Map.put(@valid_atrrs, :password, "12345")
    changeset = User.registration_changeset(%User{}, attrs)
    assert {:password, {"should be at least %{count} character(s)", count: 6}}
      in changeset.errors
  end

  test "registration_changest with valid attributes hashes password" do
    attrs = Map.put(@valid_atrrs, :password, "123456")
    changeset = User.registration_changeset(%User{}, attrs)
    %{password: pass, password_hash: pass_hash } = changeset.changes
    assert changeset.valid?
    assert pass_hash
    assert Comeonin.Bcrypt.checkpw(pass, pass_hash)
  end
end
