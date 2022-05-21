defmodule Vapor.Helpers.EmbedHelper do
  @moduledoc """
  Module to help with building Discord embeds
  """
  alias Nostrum.Struct.Embed
  alias Nostrum.Struct.Embed.{Footer, Image, Field}

  def error_embed(title, body) do
    %Embed{
      color: 15_158_332,
      title: title,
      description: body
    }
  end

  def warning_embed(title, body) do
    %Embed{
      color: 15_158_332,
      title: title,
      description: body
    }
  end

  def info_embed(title, body) do
    %Embed{
      color: 3_447_003,
      title: title,
      description: body
    }
  end

  def game_added_embed(game_details, requester) do
    %Embed{
      color: 7_419_530,
      title: "#{game_details["name"]} added to wishlist!",
      image: %Image{url: game_details["header_image"]},
      url: "https://store.steampowered.com/app/#{game_details["steam_appid"]}",
      footer: %Footer{text: "Requested by #{requester.username}"},
      timestamp: DateTime.utc_now(),
      description: game_details["short_description"] || ""
    }
  end

  def wishlist_embed([]),
    do: info_embed("Wishlist is empty", "Add a game with `!wishlist add <steam_id>`")

  def wishlist_embed(games) do
    %Embed{
      color: 3_447_003,
      title: "Current Wishlist",
      timestamp: DateTime.utc_now(),
      fields: games_to_fields(games)
    }
  end

  def on_sale_embed(games) do
    %Embed{
      color: 15_277_667,
      title: "Currently On Sale",
      timestamp: DateTime.utc_now(),
      fields: games_to_fields(games)
    }
  end

  defp games_to_fields(games) do
    Enum.map(games, fn game ->
      %Field{
        name: game.name,
        value: "https://store.steampowered.com/app/#{game.id}\nSteam Id: #{game.steam_id}",
        inline: false
      }
    end)
  end
end
