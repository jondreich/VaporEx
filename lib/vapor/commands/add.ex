defmodule Vapor.Commands.Add do
  @moduledoc """
  Command for adding a game to the wishlist

  `!wishlist add <steam_id>`
  """
  require Logger

  import Vapor.Helpers.EmbedHelper
  alias Nostrum.Api
  alias Vapor.Services.Steam
  alias Vapor.Data.Wishlist

  @spec run(list, Nostrum.Struct.Message.t()) :: {:ok, Nostrum.Struct.Message.t()}
  def run([], _msg), do: {:error, "No game ID was provided"}

  def run(params, msg) do
    case Steam.app_details(List.first(params)) do
      :error ->
        Api.create_message(msg.channel_id,
          embed:
            error_embed(
              "Game not added",
              "Error occurred while getting game with ID `#{List.first(params)}`"
            )
        )

      %{"success" => false} ->
        Api.create_message(msg.channel_id,
          embed:
            error_embed(
              "Game not added",
              "Steam game with ID `#{List.first(params)}` was not found"
            )
        )

      %{"data" => data} ->
        case add_game_to_wishlist(data, msg.author) do
          true ->
            Api.create_message(msg.channel_id, embed: game_added_embed(data, msg.author))

          [steam_id: {"already added", _constraint}] ->
            Api.create_message(msg.channel_id,
              embed: info_embed("Game not added", "#{data["name"]} is already on wishlist")
            )

          _any ->
            Api.create_message(msg.channel_id,
              embed:
                error_embed(
                  "Game not added",
                  "Error occurred while adding `#{data["name"]}` to wishlist"
                )
            )
        end
    end
  end

  defp add_game_to_wishlist(game_details, user) do
    new_game_attrs =
      %{
        steam_id: game_details["steam_appid"],
        name: game_details["name"],
        short_description: game_details["short_description"],
        requester_discord_id: user.id
      }
      |> Map.merge(Steam.price_info(game_details))

    case Wishlist.create_wishlist_game(new_game_attrs) do
      {:ok, _} -> true
      {:error, changeset} -> changeset.errors
    end
  end
end
