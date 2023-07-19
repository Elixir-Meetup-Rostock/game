defmodule Extension.MovementTest do
  use ExUnit.Case, async: true

  alias Extension.Movement

  describe "Extension.Movement" do
    test "get angle from vector" do
      assert Movement.get_angle({1, 0}, :deg) == 0
      assert Movement.get_angle({1, 1}, :deg) == 45
      assert Movement.get_angle({0, 1}, :deg) == 90
      assert Movement.get_angle({-1, 1}, :deg) == 135
      assert Movement.get_angle({-1, 0}, :deg) == 180
      assert Movement.get_angle({-1, -1}, :deg) == -135
      assert Movement.get_angle({0, -1}, :deg) == -90
      assert Movement.get_angle({1, -1}, :deg) == -45
    end

    test "it doesn't move with vector {0, 0}" do
      assert {0, 0} = Movement.move({0, 0}, {0, 0}, 10)
    end

    test "it doesn't move without speed" do
      assert {0, 0} = Movement.move({0, 0}, {1, 1}, 0)
    end

    test "it moves with full speed in one direction" do
      assert {10, 0} = Movement.move({0, 0}, {1, 0}, 10)
      assert {0, 10} = Movement.move({0, 0}, {0, 1}, 10)
    end

    test "it moves in that direction" do
      assert {7, 7} = Movement.move({0, 0}, {1, 1}, 10)
      assert {9, 5} = Movement.move({0, 0}, {5, 3}, 10)
      assert {3, -10} = Movement.move({0, 0}, {2, -7}, 10)
    end

    test "new position is added to your current position" do
      assert {12, 10} = Movement.move({5, 3}, {1, 1}, 10)
      assert {21, 22} = Movement.move({12, 17}, {5, 3}, 10)
    end
  end
end
