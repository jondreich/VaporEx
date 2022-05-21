defmodule Vapor.Commands.Show do
  @moduledoc """
  Show command

  `!wishlist show`
  """
  require Logger

  alias Nostrum.Api
  alias Vapor.Data.Wishlist
  alias Vapor.Helpers.EmbedHelper

  @spec run(list, Nostrum.Struct.Message.t()) :: {:ok, Nostrum.Struct.Message.t()}
  def run(_params, msg) do
    Wishlist.all_games()
    |> EmbedHelper.wishlist_embed()
    |> send_wishlist(msg)
  end

  defp send_wishlist(embed, msg) do
    Api.create_message(msg.channel_id, embed: embed)
  end
end
