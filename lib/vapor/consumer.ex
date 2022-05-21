defmodule Vapor.Consumer do
  @moduledoc """
  Discord message consumer and event handler
  """
  use Nostrum.Consumer

  alias Vapor.Commands.{Ping, Add, Show, CheckSales}

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case parse_command(msg.content) do
      [command | params] ->
        handle_command(command, params, msg)

      _ ->
        :ignore
    end
  end

  def handle_event(_event), do: :noop

  @spec handle_command(any, any, any) :: true
  def handle_command(command, params, msg) do
    case command do
      "pingu" ->
        Ping.run(params, msg)

      "add" ->
        Add.run(params, msg)

      "show" ->
        Show.run(params, msg)

      "checksales" ->
        CheckSales.run(params, msg)

      _ ->
        :ignore
    end

    true
  end

  defp parse_command("!wishlist" <> args) do
    String.split(args)
  end

  defp parse_command(_any), do: false
end
