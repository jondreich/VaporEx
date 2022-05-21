defmodule Vapor.Commands.Ping do
  @moduledoc """
  Ping command

  `!wishlist pingu`
  """
  require Logger

  alias Nostrum.Api

  @spec run(list, Nostrum.Struct.Message.t()) :: :ok
  def run(_params, msg) do
    case send_pingu(msg) do
      {:ok, _msg} ->
        :ok

      _error ->
        Logger.error("Penguin failed to send")
        :ok
    end
  end

  defp send_pingu(msg) do
    Api.create_message(msg.channel_id, content: "🐧")
  end
end
