defmodule Vapor.Consumer.InteractionCreate do
  @moduledoc """
  Handler for interactions (slash commands)

  The logic in here is kind of hot garbage, a more permanent/extensible solution is needed
  """
  require Logger

  import Vapor.Helpers.EmbedHelper
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias Vapor.Commands.{Ping, Add, Show, CheckSales}

  @spec handle(Interaction.t()) :: :ok
  def handle(%Interaction{data: data, user: user} = interaction) do
    response =
      case data.name do
        "pingu" ->
          Ping.run([])

        "wishlist" ->
          handle_wishlist(data.options, user)
      end
      |> get_response()

    Api.create_interaction_response!(interaction, response)
    :ok
  end

  defp handle_wishlist([option], user) do
    case option.name do
      "add" ->
        Add.run([List.first(option.options).value], user)

      "show" ->
        Show.run([])

      "checksales" ->
        CheckSales.run([])

      _ ->
        Logger.warn("Command #{option.name} not found")
        embed("Command #{option.name} not found", :warning)
    end
  end

  defp get_response(content) when is_binary(content) do
    %{
      type: 4,
      data: %{
        content: content
      }
    }
  end

  defp get_response(embed) do
    %{
      type: 4,
      data: %{
        embeds: [embed]
      }
    }
  end
end
