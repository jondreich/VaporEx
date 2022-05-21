defmodule Vapor.Repo.Migrations.CreateWishlist do
  use Ecto.Migration

  def change do
    create table(:wishlist) do
      add :steam_id, :bigint, null: false
      add :name, :string, null: false
      add :short_description, :text
      add :requester_discord_id, :bigint
      add :last_sale_percent, :integer
      add :initial_price, :integer
      add :final_price, :integer

      timestamps()
    end

    create index("wishlist", [:requester_discord_id])
    create index("wishlist", [:id], where: "last_sale_percent > 0", name: :on_sale_games_index)
    create unique_index("wishlist", [:steam_id])
  end
end
