import Config

config :vapor, Vapor.Repo,
  username: "postgres",
  password: "postgres",
  database: "vapor_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :vapor,
  job_channel_id: 846470743113859082

config :vapor, :steam, base_url: "https://store.steampowered.com/api/"
