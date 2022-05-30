defmodule Vapor.Commands.CheckSales do
  @moduledoc """
  Command for viewing the list of currently on-sale games

  `!wishlist checksales`
  """
  require Logger

  import Vapor.Helpers.EmbedHelper
  import Nostrum.Struct.Embed
  alias Vapor.Services.Steam

  @spec run(list()) :: Nostrum.Struct.Embed.t()
  def run(_params) do
    case Steam.get_all_sales() do
      [] ->
        embed("No sales found", :info)
        |> put_description("No wishlisted games currently on sale.")

      games ->
        embed("Current sales")
        |> put_games(games)
    end
  end
end
