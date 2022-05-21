defmodule Vapor.Data.Schema.WishlistGame do
  @moduledoc false
  use TypedEctoSchema
  import Ecto.Changeset

  typed_schema "wishlist" do
    field(:steam_id, :integer)
    field(:name, :string)
    field(:short_description, :string)
    field(:requester_discord_id, :integer)
    field(:last_sale_percent, :integer, default: 0)
    field(:initial_price, :integer)
    field(:final_price, :integer)

    timestamps()
  end

  def changeset(wishlist_game, attrs) do
    wishlist_game
    |> cast(attrs, [
      :steam_id,
      :name,
      :short_description,
      :requester_discord_id,
      :last_sale_percent,
      :initial_price,
      :final_price
    ])
    |> validate_required([:steam_id, :name])
    |> unique_constraint([:steam_id], message: "already added")
  end
end
