defmodule Game.Board.Tile do
  @moduledoc """
  Represents a tile, that can be drawn on a board
  """

  @enforce_keys [:x, :y]

  @derive Jason.Encoder

  defstruct [
    :x,
    :y
  ]
end
