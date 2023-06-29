defmodule Game.StateTest do
  use Game.DataCase, async: true

  alias Game.State

  describe "GenServer is automaticly started" do
    test "has a pid and is running" do
      pid = Process.whereis(State)

      refute pid === nil

      assert Process.alive?(pid) === true
    end
  end
end
