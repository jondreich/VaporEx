import Config

config :vapor, Vapor.Repo,
  username: "postgres",
  password: "postgres",
  database: "vapor_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :vapor, Oban, testing: :inline

config :vapor, :steam, base_url: "https://store.steampowered.com/api/"

import_config "test.secret.exs"
