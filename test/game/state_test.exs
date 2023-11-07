defmodule Game.StateTest do
  use Game.DataCase, async: true

  alias Game.State

  describe "GenServer is automatically started" do
    test "has a pid and is running" do
      pid = Process.whereis(State)

      refute pid === nil

      assert Process.alive?(pid) === true
    end
  end

  describe "players" do
    test "can list players" do
      assert is_list(State.list_players())
    end

    test "can list other players" do
      State.add_player("1", %{name: "one"})
      State.add_player("2", %{name: "two"})

      other_players = State.list_other_players("1")

      refute other_players |> Enum.find(&(&1.id === "1"))

      assert other_players |> Enum.find(&(&1.id === "2"))
    end

    test "can get spawn" do
      State.add_player("3", %{name: "three", x: 32, y: 32})
      State.add_player("4", %{name: "four"})
      assert {_, _} = State.get_free_spawn()
    end

    test "spawn fallback if board is full" do
      # fill board
      spawn_n(25)
      {x, y} = State.get_free_spawn()
      assert {x, y} == {32, 32}
    end
  end

  defp spawn_n(0), do: :ok

  defp spawn_n(n) do
    State.add_player("spawned_#{n}", %{name: "spawned_name_#{n}"})
    spawn_n(n - 1)
  end
end
