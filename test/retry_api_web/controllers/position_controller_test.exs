defmodule RetryApiWeb.PositionControllerTest do
  use RetryApiWeb.ConnCase

  alias RetryApi.Data
  alias RetryApi.Data.Position

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:position) do
    {:ok, position} = Data.create_position(@create_attrs)
    position
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all positions", %{conn: conn} do
      conn = get(conn, Routes.position_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create position" do
    test "renders position when data is valid", %{conn: conn} do
      conn = post(conn, Routes.position_path(conn, :create), position: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.position_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.position_path(conn, :create), position: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update position" do
    setup [:create_position]

    test "renders position when data is valid", %{conn: conn, position: %Position{id: id} = position} do
      conn = put(conn, Routes.position_path(conn, :update, position), position: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.position_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, position: position} do
      conn = put(conn, Routes.position_path(conn, :update, position), position: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete position" do
    setup [:create_position]

    test "deletes chosen position", %{conn: conn, position: position} do
      conn = delete(conn, Routes.position_path(conn, :delete, position))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.position_path(conn, :show, position))
      end
    end
  end

  defp create_position(_) do
    position = fixture(:position)
    {:ok, position: position}
  end
end
