defmodule Game.Board.Tiles.Tile do
  @moduledoc """
  Represents a tile, that can be drawn on a board
  """

  @enforce_keys [:id, :sprite, :sprite_x, :sprite_y]

  @derive Jason.Encoder

  defstruct [:id, :sprite, :sprite_x, :sprite_y, x: 0, y: 0, size: 16, frames: 0]
end
