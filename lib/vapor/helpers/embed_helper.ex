defmodule Vapor.Helpers.EmbedHelper do
  @moduledoc """
  Module to help with building Discord embeds
  """
  import Vapor.Helpers.ColorHelper
  import Nostrum.Struct.Embed
  alias Nostrum.Struct.Embed
  alias Nostrum.Struct.Embed.Field

  @spec embed(String.t(), :error | :info | :primary | :success | :warning) :: Embed.t()
  def embed(title, color \\ :primary) do
    %Embed{
      color: color(color),
      title: title,
      timestamp: DateTime.to_string(DateTime.utc_now())
    }
  end

  @spec put_game_details(Nostrum.Struct.Embed.t(), map()) :: Embed.t()
  def put_game_details(embed, game_details) do
    embed
    |> put_image(game_details["header_image"])
    |> put_url("https://store.steampowered.com/app/#{game_details["steam_appid"]}")
    |> put_description(game_details["short_description"] || "")
  end

  @spec put_games(Embed.t(), list(Vapor.Data.Schema.WishlistGame.t())) :: Embed.t()
  def put_games(embed, games) do
    Kernel.struct(embed, %{fields: games_to_fields(games)})
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
