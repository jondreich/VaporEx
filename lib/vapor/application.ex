defmodule Vapor.Application do
  @moduledoc false
  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      Vapor.Repo,
      Vapor.Consumer,
      Vapor.Scheduler
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
