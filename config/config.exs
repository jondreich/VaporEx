import Config

config :vapor,
  ecto_repos: [Vapor.Repo]

config :vapor, Vapor.Scheduler,
  jobs: [
    check_sales: [
      schedule: {:cron, "* */6 * * *"},
      task: {Vapor.WishlistWorker, :perform, []}
    ]
  ]

import_config "#{Mix.env()}.exs"
