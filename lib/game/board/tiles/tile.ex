defmodule Game.Board.Tiles.Tile do
  @moduledoc """
  Represents a tile, that can be drawn on a board
  """

  @default_size 16

  @enforce_keys [:id, :sprite]

  @derive Jason.Encoder

  defstruct [
    :id,
    :sprite,
    x: 0,
    y: 0,
    size: @default_size,
    width: @default_size,
    height: @default_size,
    frames: 0
  ]
end
