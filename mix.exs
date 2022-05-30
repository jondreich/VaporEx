defmodule Vapor.MixProject do
  use Mix.Project

  def project do
    [
      app: :vapor,
      version: "0.2.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Vapor.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nostrum, "~> 0.5.1"},
      {:httpoison, "~> 1.8"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:typed_ecto_schema, "~> 0.4.1", runtime: false},
      {:quantum, "~> 3.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      s: ["run --no-halt"]
    ]
  end
end
