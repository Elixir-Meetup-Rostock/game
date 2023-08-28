defmodule Game.Board.MapTest do
  use Game.DataCase, async: true

  alias Game.Board.Map

  describe "map" do
    test "get returns a map with tuple-key" do
      map = Map.get()

      assert is_map(map)
      assert map |> Enum.all?(&match?({{_x, _y}, _type}, &1))
    end
  end
end
