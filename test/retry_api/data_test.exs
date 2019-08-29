defmodule RetryApi.DataTest do
  use RetryApi.DataCase

  alias RetryApi.Data

  describe "positions" do
    alias RetryApi.Data.Position

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def position_fixture(attrs \\ %{}) do
      {:ok, position} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_position()

      position
    end

    test "list_positions/0 returns all positions" do
      position = position_fixture()
      assert Data.list_positions() == [position]
    end

    test "get_position!/1 returns the position with given id" do
      position = position_fixture()
      assert Data.get_position!(position.id) == position
    end

    test "create_position/1 with valid data creates a position" do
      assert {:ok, %Position{} = position} = Data.create_position(@valid_attrs)
    end

    test "create_position/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_position(@invalid_attrs)
    end

    test "update_position/2 with valid data updates the position" do
      position = position_fixture()
      assert {:ok, %Position{} = position} = Data.update_position(position, @update_attrs)
    end

    test "update_position/2 with invalid data returns error changeset" do
      position = position_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_position(position, @invalid_attrs)
      assert position == Data.get_position!(position.id)
    end

    test "delete_position/1 deletes the position" do
      position = position_fixture()
      assert {:ok, %Position{}} = Data.delete_position(position)
      assert_raise Ecto.NoResultsError, fn -> Data.get_position!(position.id) end
    end

    test "change_position/1 returns a position changeset" do
      position = position_fixture()
      assert %Ecto.Changeset{} = Data.change_position(position)
    end
  end
end
