defmodule Vapor.Commands.CheckSales do
  @moduledoc """
  Command for viewing the list of currently on-sale games

  `!wishlist checksales`
  """
  require Logger

  alias Nostrum.Api

  alias Vapor.Services.Steam
  alias Vapor.Helpers.EmbedHelper

  @spec run(list, Nostrum.Struct.Message.t()) :: {:ok, Nostrum.Struct.Message.t()}
  def run(_params, msg) do
    Steam.get_all_sales()
    |> EmbedHelper.on_sale_embed()
    |> send_sales(msg)
  end

  defp send_sales(embed, msg) do
    Api.create_message(msg.channel_id, embed: embed)
  end
end
