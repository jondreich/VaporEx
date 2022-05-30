defmodule Vapor.Consumer do
  @moduledoc """
  Consumes events sent by the gateway
  """
  use Nostrum.Consumer

  alias __MODULE__.{
    InteractionCreate,
    MessageCreate
  }

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}), do: MessageCreate.handle(msg)

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}),
    do: InteractionCreate.handle(interaction)

  def handle_event(_event), do: :noop
end
