defmodule Game.State.Projectiles.ProjectileTest do
  use Game.DataCase, async: true

  alias Game.State.Projectiles.Projectile

  @id "random-id"

  describe "Projectile fields" do
    test "has nessessary fields" do
      projectile = %Projectile{id: @id, x_vector: 10, y_vector: 20}

      assert %Projectile{id: @id, x: 0, y: 0, x_vector: 10, y_vector: 20, speed: 1, range: 100} =
               projectile
    end
  end

  # describe "player actions" do
  #   test "all actions are initially false" do
  #     player = %Player{id: @id, name: @name}

  #     assert %{actions: actions} = player
  #     assert actions |> Map.values() |> Enum.all?(&(&1 === false))
  #   end

  #   test "can update action" do
  #     player = %Player{id: @id, name: @name}

  #     assert %{actions: %{up: true}} = Player.set_action(player, :up, true)
  #     assert %{actions: %{left: true}} = Player.set_action(player, :left, true)
  #     assert %{actions: %{right: true}} = Player.set_action(player, :right, true)
  #     assert %{actions: %{down: true}} = Player.set_action(player, :down, true)

  #     assert %{actions: %{space: true}} = Player.set_action(player, :space, true)
  #   end
  # end

  # describe "player tick" do
  #   test "no position update on tick, if no action is true" do
  #     player = %Player{id: @id, name: @name}

  #     assert %{x: 0, y: 0} = Player.tick(player)
  #   end

  #   test "no position update on tick, if opposite action is true" do
  #     player = %Player{id: @id, name: @name}

  #     player_y = player |> Player.set_action(:up, true) |> Player.set_action(:down, true)
  #     player_x = player |> Player.set_action(:left, true) |> Player.set_action(:right, true)

  #     assert %{x: 0, y: 0} = Player.tick(player_y)
  #     assert %{x: 0, y: 0} = Player.tick(player_x)
  #   end

  #   test "update position on tick, when action is true" do
  #     player = %Player{id: @id, name: @name}
  #     s_pl = player.speed
  #     s_mi = -player.speed

  #     assert %{x: 0, y: ^s_mi} = player |> Player.set_action(:up, true) |> Player.tick()
  #     assert %{x: ^s_mi, y: 0} = player |> Player.set_action(:left, true) |> Player.tick()
  #     assert %{x: ^s_pl, y: 0} = player |> Player.set_action(:right, true) |> Player.tick()
  #     assert %{x: 0, y: ^s_pl} = player |> Player.set_action(:down, true) |> Player.tick()
  #   end
  # end
end
