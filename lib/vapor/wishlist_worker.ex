defmodule Vapor.WishlistWorker do
  @moduledoc """
  Runs once every 8 hours
  Checks for new sales and sends message if any are found
  """
  require Logger

  use Oban.Worker, queue: :sales_job_queue

  alias Nostrum.Api
  alias Vapor.Services.Steam
  alias Vapor.Helpers.EmbedHelper

  @impl Oban.Worker
  @spec perform(any) :: :ok
  def perform(_args) do
    Logger.info("Starting wishlist job")

    Steam.get_new_sales()
    |> send_sales_message()

    :ok
  end

  defp send_sales_message([]), do: :noop

  defp send_sales_message(games) do
    channel_id = Application.fetch_env!(:vapor, :job_channel_id)
    Api.create_message(channel_id, embed: EmbedHelper.wishlist_embed(games))
  end
end
