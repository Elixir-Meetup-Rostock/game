defmodule Game.Board.Tiles.TileTest do
  use Game.DataCase, async: true

  alias Game.Board.Tiles.Tile

  @x :rand.uniform(1000)
  @y :rand.uniform(1000)

  describe "tile fields" do
    test "has nessessary fields" do
      tile = %Tile{id: 1, sprite: "map", sprite_x: @x, sprite_y: @y}

      assert %Tile{id: 1, sprite: "map", sprite_x: @x, sprite_y: @y} = tile
      assert %Tile{id: 1, x: 0, y: 0, size: 16, frames: 0} = tile
    end
  end
end
