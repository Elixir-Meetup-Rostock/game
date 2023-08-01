defmodule Game.Board.TilesTest do
  use Game.DataCase, async: true

  alias Game.Board.Tiles
  alias Game.Board.Tiles.Tile

  describe "tiles" do
    test "can list of tiles" do
      tile_list = Tiles.list()

      assert is_list(tile_list)
      assert Enum.all?(tile_list, &match?(%Tile{}, &1))
    end

    test "can get a specific tile" do
      [tile | _] = Tiles.list()

      assert %Tile{} = Tiles.get(tile.id)
    end
  end
end
