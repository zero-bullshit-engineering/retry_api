defmodule RetryApi.Repo do
  use Ecto.Repo,
    otp_app: :retry_api,
    adapter: Ecto.Adapters.Postgres
end
