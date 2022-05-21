defmodule Vapor.Data.Wishlist do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Vapor.Repo
  alias Vapor.Data.Schema.WishlistGame

  @spec all_games :: list(WishlistGame.t())
  def all_games do
    Repo.all(WishlistGame)
  end

  @spec all_game_ids :: list({integer(), integer()})
  def all_game_ids do
    query =
      from(g in WishlistGame,
        select: {g.id, g.steam_id}
      )

    Repo.all(query)
  end

  def on_sale_games do
    query =
      from(g in WishlistGame,
        where: g.last_sale_percent > 0
      )

    Repo.all(query)
  end

  @spec update_game(map(), integer()) :: WishlistGame.t()
  def update_game(attrs, id) do
    Repo.get(WishlistGame, id)
    |> WishlistGame.changeset(attrs)
    |> Repo.update!()
  end

  @spec create_wishlist_game(map()) :: {:ok, WishlistGame.t()} | {:error, Ecto.Changeset.t()}
  def create_wishlist_game(attrs \\ %{}) do
    %WishlistGame{}
    |> WishlistGame.changeset(attrs)
    |> Repo.insert()
  end
end
