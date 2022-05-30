defmodule Vapor.Helpers.ColorHelper do
  @moduledoc """
  Contains color constants and a function to retrieve them by atom
  """

  @doc ~S"""
  Returns the decimal color for a given atom from our predefined set

  ## Examples

      iex> Vapor.Helpers.ColorHelper.color(:warning)
      16763965

  """
  @spec color(:error | :warning | :success | :info | :primary) :: any
  def color(color), do: apply(__MODULE__, color, [])

  @spec error :: 16_730_441
  def error(), do: 16_730_441

  @spec warning :: 16_763_965
  def warning(), do: 16_763_965

  @spec success :: 1_298_022
  def success(), do: 1_298_022

  @spec info :: 2_985_727
  def info(), do: 2_985_727

  @spec primary :: 4_531_844
  def primary(), do: 4_531_844
end
