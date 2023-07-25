defmodule Game.MapTest do
  use Game.DataCase, async: true

  alias Game.Map, as: GameMap

  describe "map" do
    test "can list sprites" do
      sprite_list = GameMap.list_sprites()

      assert is_list(sprite_list)
    end
  end
end
