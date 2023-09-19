defmodule Game.Board.Tiles.TileTest do
  use Game.DataCase, async: true

  alias Game.Board.Tiles.Tile

  describe "tile fields" do
    test "has nessessary fields" do
      tile = %Tile{id: 1, sprite: "map"}

      assert %Tile{id: 1, sprite: "map", x: 0, y: 0, size: 16, frames: 0} = tile
    end
  end
end
