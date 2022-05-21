defmodule Vapor.Repo do
  use Ecto.Repo,
    otp_app: :vapor,
    adapter: Ecto.Adapters.Postgres
end
