defmodule Game.State.Players.PlayerTest do
  use Game.DataCase, async: true

  alias Game.State.Players.Player

  @id "random-id"
  @name "lorem ipsum"

  describe "player fields" do
    test "has nessessary fields" do
      player = %Player{id: @id, name: @name}

      assert %Player{id: @id, name: @name, x: 0, y: 0, hp: 100, speed: 1, actions: actions} =
               player

      assert Enum.sort(Map.keys(actions)) === Enum.sort([:up, :down, :left, :right, :space])
    end
  end

  describe "player actions" do
    test "all actions are initially false" do
      player = %Player{id: @id, name: @name}

      assert %{actions: actions} = player
      assert actions |> Map.values() |> Enum.all?(&(&1 === false))
    end

    test "can update action" do
      player = %Player{id: @id, name: @name}

      assert %{actions: %{up: true}} = Player.set_action(player, :up, true)
      assert %{actions: %{left: true}} = Player.set_action(player, :left, true)
      assert %{actions: %{right: true}} = Player.set_action(player, :right, true)
      assert %{actions: %{down: true}} = Player.set_action(player, :down, true)

      assert %{actions: %{space: true}} = Player.set_action(player, :space, true)
    end
  end

  describe "player tick" do
    test "no position update on tick, if no action is true" do
      player = %Player{id: @id, name: @name}

      assert %{x: 0, y: 0} = Player.tick(player, [])
    end

    test "no position update on tick, if opposite action is true" do
      player = %Player{id: @id, name: @name}

      player_y = player |> Player.set_action(:up, true) |> Player.set_action(:down, true)
      player_x = player |> Player.set_action(:left, true) |> Player.set_action(:right, true)

      assert %{x: 0, y: 0} = Player.tick(player_y, [])
      assert %{x: 0, y: 0} = Player.tick(player_x, [])
    end

    test "update position on tick, when action is true" do
      player = %Player{id: @id, name: @name}
      s_pl = player.speed
      s_mi = -player.speed

      assert %{x: 0, y: ^s_mi} = player |> Player.set_action(:up, true) |> Player.tick([])
      assert %{x: ^s_mi, y: 0} = player |> Player.set_action(:left, true) |> Player.tick([])
      assert %{x: ^s_pl, y: 0} = player |> Player.set_action(:right, true) |> Player.tick([])
      assert %{x: 0, y: ^s_pl} = player |> Player.set_action(:down, true) |> Player.tick([])
    end
  end
end
