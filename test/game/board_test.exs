defmodule Game.BoardTest do
  use Game.DataCase, async: true

  alias Game.Board
  alias Game.State

  describe "board" do
    test "list_sprites/0 returns a list of all used sprites" do
      sprites = Board.list_sprites()

      assert is_list(sprites)
      assert sprites |> Enum.all?(&match?(%{file: _, key: _}, &1))
    end

    test "get_layers/1 returns a list with each level and it's tiles" do
      layers = Board.get_layers("1")

      assert is_list(layers)
      assert layers |> Enum.all?(&match?(%{level: _, tiles: _}, &1))
    end

    test "get_player/1 returns the current player" do
      State.add_player("1", %{name: "one"})

      assert %{id: "1", sprite: "player"} = Board.get_player("1")
    end
  end
end
