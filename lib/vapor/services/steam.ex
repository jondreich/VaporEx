defmodule Vapor.Services.Steam do
  @moduledoc """
  Custom module for Steam interaction and related logic
  """
  require Logger

  alias Vapor.Data.Wishlist
  alias Vapor.Data.Schema.WishlistGame

  @base_url Application.compile_env(:vapor, [:steam, :base_url])
  # @key Application.get_env(:vapor, [:steam, :key])

  @spec app_details(integer()) :: any()
  def app_details(app_id) do
    url = Path.join(@base_url, "appdetails")

    case HTTPoison.get!(url, headers(), params: [appids: app_id]) do
      %HTTPoison.Response{status_code: 200} = res ->
        Jason.decode!(res.body)["#{app_id}"]

      _any ->
        Logger.error("Steam API request failed")
        :error
    end
  end

  @spec get_all_sales :: list(WishlistGame.t())
  def get_all_sales do
    Enum.map(Wishlist.all_games(), fn %{id: id, steam_id: steam_id} ->
      case app_details(steam_id) do
        %{"data" => data} ->
          Map.merge(%{id: id, steam_id: steam_id}, price_info(data))
          |> Wishlist.update_game(id)

        _else ->
          nil
      end
    end)
    |> Enum.filter(fn game -> !!game and game.last_sale_percent > 0 end)
  end

  @spec get_new_sales :: list(WishlistGame.t())
  def get_new_sales do
    Enum.map(Wishlist.all_games(), fn %{
                                        id: id,
                                        steam_id: steam_id,
                                        last_sale_percent: old_percent
                                      } ->
      case app_details(steam_id) do
        %{"data" => data} ->
          Map.merge(%{id: id, steam_id: steam_id}, price_info(data))
          |> Wishlist.update_game(id)
          |> check_sale_new(old_percent)

        _else ->
          nil
      end
    end)
    |> Enum.filter(fn game -> !!game and game.last_sale_percent > 0 end)
  end

  def price_info(%{
        "price_overview" => %{
          "discount_percent" => discount_percent,
          "initial" => initial,
          "final" => final
        }
      }) do
    %{last_sale_percent: discount_percent, initial_price: initial, final_price: final}
  end

  defp check_sale_new(game, old_percent) do
    if game.last_sale_percent == old_percent,
      do: nil,
      else: game
  end

  defp headers do
    [{"Content-Type", "application/json"}]
  end
end
