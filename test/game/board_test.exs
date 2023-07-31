defmodule Game.BoardTest do
  use Game.DataCase, async: true

  alias Game.Board
  alias Game.Board.Tile
  alias Game.State.Players

  @id1 "random-id-1"
  @name1 "lorem ipsum 1"
  @id2 "random-id-2"
  @name2 "lorem ipsum 2"

  describe "board" do
    test "can list sprites" do
      sprite_list = Board.list_sprites()

      assert is_list(sprite_list)
      assert %{key: "map", file: _} = Enum.find(sprite_list, &(&1.key === "map"))
    end

    test "can get unique tiles" do
      tiles = Board.list_tiles()

      assert is_map(tiles)

      assert tiles |> Map.to_list() |> Enum.all?(&match?({_, %Tile{}}, &1))
    end

    test "can get board as list of tiles" do
      board_list = Board.get()

      assert is_list(board_list)
      assert Enum.all?(board_list, &match?(%Tile{}, &1))
    end

    test "can list other players" do
      Players.add(@id1, %{name: @name1})
      Players.add(@id2, %{name: @name2})

      other_players = Board.list_other_players(@id1)

      refute other_players |> Enum.find(&(&1.id === @id1))

      assert other_players |> Enum.find(&(&1.id === @id2))
    end
  end
end
