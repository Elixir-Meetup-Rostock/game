defmodule Game.Board.Tile do
  @moduledoc """
  Represents a tile, that can be drawn on a board

  z for a tile refers to the order of drawing tiles on the board canvas.
  Lower z means the tile is drawn first, and thus is behind other tiles.
  E.g. the background water tile has a z of 0, and the player has a z of 1. Trees that the player can walk behind have a z of 2.
  """

  @enforce_keys [:id, :sprite, :sprite_x, :sprite_y]

  @derive Jason.Encoder

  defstruct [
    :id,
    :sprite,
    :sprite_x,
    :sprite_y,
    x: 0,
    y: 0,
    z: 0,
  ]
end
