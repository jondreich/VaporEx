defmodule Vapor.Commands.Add do
  @moduledoc """
  Command for adding a game to the wishlist

  `!wishlist add <steam_id>`
  """
  require Logger

  import Vapor.Helpers.EmbedHelper
  import Nostrum.Struct.Embed
  alias Vapor.Services.Steam
  alias Vapor.Data.Wishlist

  @spec run(list, Nostrum.Struct.User.t()) :: Nostrum.Struct.Embed.t()
  def run([], _user), do: {:error, "No game ID was provided"}

  def run(params, user) do
    case Steam.app_details(List.first(params)) do
      :error ->
        embed("Game not added", :error)
        |> put_description("Error occurred while getting game with ID `#{List.first(params)}`")

      %{"success" => false} ->
        embed("Game not added", :error)
        |> put_description("Steam game with ID `#{List.first(params)}` was not found")

      %{"data" => data} ->
        case add_game_to_wishlist(data, user) do
          true ->
            embed("#{data["name"]} added to wishlist!", :primary)
            |> put_description(data["short_description"] || "")
            |> put_url("https://store.steampowered.com/app/#{data["steam_appid"]}")
            |> put_image(data["header_image"])
            |> put_footer("Requested by #{user.username}")

          [steam_id: {"already added", _constraint}] ->
            embed("Game not added", :info)
            |> put_description("#{data["name"]} is already on wishlist")

          _any ->
            embed("Game not added", :error)
            |> put_description("Error occurred while adding `#{data["name"]}` to wishlist")
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
