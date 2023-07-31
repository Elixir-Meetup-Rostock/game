defmodule Game.BoardTest do
  use Game.DataCase, async: true

  alias Game.Board
  alias Game.Board.Tile

  describe "board" do
    test "can list sprites" do
      sprite_list = Board.list_sprites()

      assert is_list(sprite_list)
      assert %{key: "map", file: _} = Enum.find(sprite_list, &(&1.key === "map"))
    end

    test "can get board as list of tiles" do
      tile_list = Board.get_tiles()

      assert is_list(tile_list)
      assert Enum.all?(tile_list, &match?(%Tile{}, &1))
    end
  end
end
