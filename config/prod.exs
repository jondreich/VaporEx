import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    """

token =
  System.get_env("TOKEN") ||
    raise """
    environment variable TOKEN is missing.
    """

steam_key =
  System.get_env("STEAM_KEY") ||
    raise """
    environment variable STEAM_KEY is missing.
    """

job_channel_id =
  System.get_env("JOB_CHANNEL_ID") ||
    raise """
    environment variable JOB_CHANNEL_ID is missing.
    """

config :vapor, Vapor.Repo,
  ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :vapor,
  job_channel_id: job_channel_id

config :nostrum,
  token: token

config :vapor, :steam,
  key: steam_key,
  base_url: "https://store.steampowered.com/api/"
