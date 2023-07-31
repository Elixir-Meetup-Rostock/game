defmodule Game.Board.TileTest do
  use Game.DataCase, async: true

  alias Game.Board.Tile

  @x :rand.uniform(1000)
  @y :rand.uniform(1000)

  describe "tile fields" do
    test "has nessessary fields" do
      tile = %Tile{id: 0, sprite: "map", sprite_x: @x, sprite_y: @y}

      assert %Tile{id: 0, sprite: "map", sprite_x: @x, sprite_y: @y, x: 0, y: 0} = tile
    end
  end
end
