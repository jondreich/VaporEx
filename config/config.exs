import Config

config :vapor,
  ecto_repos: [Vapor.Repo]

config :vapor, Oban,
  repo: Vapor.Repo,
  queues: [sales_job_queue: 1],
  plugins: [
    {Oban.Plugins.Cron, crontab: [{"* */8 * * *", Vapor.WishlistWorker, unique: [period: 30]}]}
  ]

import_config "#{Mix.env()}.exs"
