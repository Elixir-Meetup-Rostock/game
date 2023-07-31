defmodule Game.Board.Tile do
  @moduledoc """
  Represents a tile, that can be drawn on a board
  """

  @enforce_keys [:x, :y, :sprite]

  @derive Jason.Encoder

  defstruct [
    :x,
    :y,
    :sprite,
    sprite_x: 0,
    sprite_y: 0
  ]
end
