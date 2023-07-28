defmodule Game.BoardTest do
  use Game.DataCase, async: true

  alias Game.Board

  @rock 1

  describe "map" do
    test "can list sprites" do
      sprite_list = Board.list_sprites()

      assert is_list(sprite_list)
      assert %{key: "map", file: _} = Enum.find(sprite_list, &(&1.key === "map"))
    end

    test "can get board as a list of lists" do
      board = Board.get_map()

      assert is_list(board)
      assert Enum.all?(board, &is_list/1)
    end

    test "all outside layers are rock" do
      board = Board.get_map()

      assert Enum.all?(board, fn line -> List.first(line) === @rock end)
      assert Enum.all?(board, fn line -> List.last(line) === @rock end)

      assert List.first(board) |> Enum.all?(&(&1 === @rock))
      assert List.last(board) |> Enum.all?(&(&1 === @rock))
    end
  end
end
