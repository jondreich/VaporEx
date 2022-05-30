defmodule Vapor.Consumer.MessageCreate do
  @moduledoc """
  Handles `MESSAGE_CREATE` events
  """
  require Logger

  import Vapor.Helpers.EmbedHelper
  alias Nostrum.Api
  alias Nostrum.Struct.Message
  alias Vapor.Commands.{Add, Ping, Show, CheckSales}

  @spec handle(Message.t()) :: :ok
  def handle(msg) do
    unless msg.author.bot do
      case parse_command(msg.content) do
        [command | params] ->
          handle_command(command, params, msg.author)
          |> send_response(msg)

        _false ->
          :noop
      end
    end

    :ok
  end

  defp handle_command(command, params, author) do
    Logger.debug("Start handling command")

    case command do
      "pingu" ->
        Ping.run(params)

      "add" ->
        Add.run(params, author)

      "show" ->
        Show.run(params)

      "checksales" ->
        CheckSales.run(params)

      _ ->
        Logger.warn("Command #{command} not found")
        embed("Command #{command} not found", :warning)
    end
  end

  defp parse_command("!wishlist" <> args) do
    String.split(args)
  end

  defp parse_command(_any), do: false

  defp send_response(content, msg) when is_binary(content),
    do: Api.create_message(msg.channel_id, content: content)

  defp send_response(embed, msg), do: Api.create_message(msg.channel_id, embed: embed)
end
