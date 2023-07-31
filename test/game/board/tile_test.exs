defmodule Game.Board.TileTest do
  use Game.DataCase, async: true

  alias Game.Board.Tile

  @x :rand.uniform(1000)
  @y :rand.uniform(1000)

  describe "tile fields" do
    test "has nessessary fields" do
      tile = %Tile{x: @x, y: @y, sprite: "map"}

      assert %Tile{x: @x, y: @y, sprite: "map", sprite_x: 0, sprite_y: 0} = tile
    end
  end
end
