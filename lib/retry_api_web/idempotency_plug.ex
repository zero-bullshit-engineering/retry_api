defmodule RetryApiWeb.IdempotencyPlug do
  import Plug.Conn
  require Logger

  def init(options \\ []) do
    defaults = [header_name: "x-idempotency-token"]
    Keyword.merge(defaults, options) |> Enum.into(%{})
  end

  defp check_header(conn, header_name) do
    case get_req_header(conn, header_name) do
      [] ->
        {:error, :no_token_in_header}

      [token] ->
        {:ok, token}
    end
  end

  def check_cache(token) do
    case :ets.lookup(:idempotency_cache, token) do
      [] ->
        {:error, :no_cached_result, token}

      [data] ->
        {:ok, data}
    end
  end

  def call(conn, %{header_name: header_name}) do
    with {:ok, token} <- check_header(conn, header_name),
         {:ok, {_key, data}} <- check_cache(token) do
      Logger.info("Responding with cached idempotency request")

      conn =
        Enum.reduce(data.resp_headers(), conn, fn {key, value}, conn ->
          put_resp_header(conn, key, value)
        end)

      conn
      |> send_resp(data.status, data.resp_body)
      |> halt
    else
      {:error, :no_token_in_header} ->
        Logger.debug("No idempotency token in request")
        conn

      {:error, :no_cached_result, token} ->
        register_before_send(conn, fn conn ->
          Logger.info("Finished request, storing results for #{token}")

          # only cache successful requests
          if conn.status < 400 do
            :ets.insert(
              :idempotency_cache,
              {token,
               %{
                 status: conn.status,
                 resp_headers: conn.resp_headers,
                 resp_body: conn.resp_body
               }}
            )
          end

          conn
        end)
    end
  end
end
