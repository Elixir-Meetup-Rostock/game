defmodule Game.State.PlayersTest do
  use Game.DataCase, async: true

  alias Game.State.Players
  alias Game.State.Players.Player

  @id1 "random-id-1"
  @name1 "lorem ipsum 1"
  @id2 "random-id-2"
  @name2 "lorem ipsum 2"

  describe "Agent is automatically started" do
    test "has a pid and is running" do
      pid = Process.whereis(Players)

      refute pid === nil

      assert Process.alive?(pid) === true
    end
  end

  describe "players" do
    test "can list players" do
      Players.add(@id1, %{name: @name1})
      Players.add(@id2, %{name: @name2})

      player_list = Players.list()

      assert is_list(player_list)
      assert player_list |> Enum.find(&(&1.id === @id1))
      assert player_list |> Enum.find(&(&1.id === @id2))
    end

    test "add player returns added player" do
      assert %Player{id: @id1, name: @name1} = Players.add(@id1, %{name: @name1})
    end

    test "can set & unset action" do
      Players.add(@id1, %{name: @name1})

      Players.set_action(@id1, :up, true)
      assert %Player{actions: %{up: true}} = Players.get(@id1)

      Players.set_action(@id1, :up, false)
      assert %Player{actions: %{up: false}} = Players.get(@id1)
    end
  end
end
