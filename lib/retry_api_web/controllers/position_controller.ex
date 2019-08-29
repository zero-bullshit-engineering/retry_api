defmodule RetryApiWeb.PositionController do
  use RetryApiWeb, :controller

  alias RetryApi.Data
  alias RetryApi.Data.Position
  plug RetryApiWeb.IdempotencyPlug when action in [:create, :update, :delete]

  action_fallback RetryApiWeb.FallbackController

  def index(conn, _params) do
    positions = Data.list_positions()
    render(conn, "index.json", positions: positions)
  end

  def create(conn, %{"position" => position_params}) do
    with {:ok, %Position{} = position} <- Data.create_position(position_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.position_path(conn, :show, position))
      |> render("show.json", position: position)
    end
  end

  def show(conn, %{"id" => id}) do
    position = Data.get_position!(id)
    render(conn, "show.json", position: position)
  end

  def update(conn, %{"id" => id, "position" => position_params}) do
    position = Data.get_position!(id)

    with {:ok, %Position{} = position} <- Data.update_position(position, position_params) do
      render(conn, "show.json", position: position)
    end
  end

  def delete(conn, %{"id" => id}) do
    position = Data.get_position!(id)

    with {:ok, %Position{}} <- Data.delete_position(position) do
      send_resp(conn, :no_content, "")
    end
  end
end
