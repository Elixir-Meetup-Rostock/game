defmodule Game.Board.SpritesTest do
  use Game.DataCase, async: true

  alias Game.Board.Sprites

  describe "sprites" do
    test "can list sprites" do
      sprite_list = Sprites.list()

      assert is_list(sprite_list)
      assert %{key: "map", file: _} = Enum.find(sprite_list, &(&1.key === "map"))
    end
  end
end
