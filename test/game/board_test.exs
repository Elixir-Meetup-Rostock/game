defmodule Game.BoardTest do
  use Game.DataCase, async: true

  alias Game.Board
  alias Game.Board.Tiles.Tile
  alias Game.State.Players

  @id1 "random-id-1"
  @name1 "lorem ipsum 1"
  @id2 "random-id-2"
  @name2 "lorem ipsum 2"

  describe "board" do
    # Board.list_sprites()

    # Board.list_tiles()

    test "can get the board as a list of tiles with x and y set" do
      board = Board.get()

      assert is_list(board)
      assert board |> Enum.all?(&match?(%Tile{}, &1))
      assert board |> Enum.filter(&(&1.x === 0 && &1.y === 0)) |> length() === 1
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
