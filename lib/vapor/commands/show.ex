defmodule Vapor.Commands.Show do
  @moduledoc """
  Show command

  `!wishlist show`
  """
  require Logger

  import Vapor.Helpers.EmbedHelper
  alias Vapor.Data.Wishlist

  @spec run(list()) :: Nostrum.Struct.Embed.t()
  def run(_params) do
    embed("Current wishlist")
    |> put_games(Wishlist.all_games())
  end
end
