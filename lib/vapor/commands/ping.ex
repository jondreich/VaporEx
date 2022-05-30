defmodule Vapor.Commands.Ping do
  @moduledoc """
  Ping command

  `!wishlist pingu`
  """

  @spec run(list()) :: String.t()
  def run(_params) do
    "🐧"
  end
end
