defmodule Game.Board.TileTest do
  use Game.DataCase, async: true

  alias Game.Board.Tile

  @x :rand.uniform(1000)
  @y :rand.uniform(1000)

  describe "tile fields" do
    test "has nessessary fields" do
      tile = %Tile{x: @x, y: @y}

      assert %Tile{x: @x, y: @y} = tile
    end
  end
end
