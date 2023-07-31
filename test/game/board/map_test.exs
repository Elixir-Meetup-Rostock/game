defmodule Game.Board.MapTest do
  use Game.DataCase, async: true

  alias Game.Board.Map

  @rock 1

  describe "map" do
    test "get returns a list of lists" do
      map = Map.get()

      assert is_list(map)
      assert Enum.all?(map, &is_list/1)
    end

    test "all outside layers are rock" do
      map = Map.get()

      assert Enum.all?(map, fn line -> List.first(line) === @rock end)
      assert Enum.all?(map, fn line -> List.last(line) === @rock end)

      assert List.first(map) |> Enum.all?(&(&1 === @rock))
      assert List.last(map) |> Enum.all?(&(&1 === @rock))
    end
  end
end
