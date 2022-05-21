import Config

config :vapor, Vapor.Repo,
  username: "postgres",
  password: "postgres",
  database: "vapor_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :vapor,
  job_channel_id: 846_470_743_113_859_082

config :vapor, :steam, base_url: "https://store.steampowered.com/api/"

import_config "dev.secret.exs"
