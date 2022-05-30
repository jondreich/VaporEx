defmodule Vapor.WishlistWorker do
  @moduledoc """
  Checks for new sales and sends message to configured job channel if any are found
  """
  require Logger

  alias Nostrum.Api
  alias Vapor.Services.Steam
  import Vapor.Helpers.EmbedHelper

  @job_channel Application.compile_env(:vapor, :job_channel_id)

  @spec perform() :: :ok
  def perform() do
    Logger.info("Starting wishlist job")

    Steam.get_new_sales()
    |> send_sales_message()

    :ok
  end

  defp send_sales_message([]), do: :noop

  defp send_sales_message(games) do
    Api.create_message(@job_channel,
      embed:
        embed("New Sales!", :info)
        |> put_games(games)
    )
  end
end
