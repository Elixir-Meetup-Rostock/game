defmodule Game.State.ProjectilesTest do
  use Game.DataCase, async: true

  alias Game.State.Projectiles
  alias Game.State.Projectiles.Projectile

  @player_id "random-id"

  describe "projectiles Agent is automatically started" do
    test "has a pid and is running" do
      pid = Process.whereis(Projectiles)

      refute pid === nil

      assert Process.alive?(pid) === true
    end
  end

  describe "projectiles state" do
    test "can list projectiles" do
      Projectiles.add(@player_id, %{x_vector: 0, y_vector: 0})

      projectiles_list = Projectiles.list()

      assert is_list(projectiles_list)
      assert projectiles_list |> Enum.find(&(&1.player_id === @player_id))
    end

    test "add projectile returns added projectile" do
      assert %Projectile{player_id: @player_id, x_vector: 10, y_vector: 10} =
               Projectiles.add(@player_id, %{x_vector: 10, y_vector: 10})
    end
  end

  describe "projectiles tick" do
    test "decrease projectile range" do
      %{range: start_range} = Projectiles.add(@player_id, %{x_vector: 10, y_vector: 10})

      Projectiles.tick()

      assert %Projectile{range: end_range} =
               Projectiles.list() |> Enum.find(&(&1.player_id === @player_id))

      assert end_range < start_range
    end

    test "remove projectiles with no range left" do
      %{range: range} = Projectiles.add(@player_id, %{x_vector: 10, y_vector: 10})

      assert Projectiles.list() |> Enum.find(&(&1.player_id === @player_id))

      ticks = range + 1
      Enum.each(1..ticks, fn _x -> Projectiles.tick() end)

      refute Projectiles.list() |> Enum.find(&(&1.player_id === @player_id))
    end

    # test "update projectile positions" do
    #   Projectiles.add(@id1, %{x_vector: 0, y_vector: 0})
    #   %{speed: speed} = Projectiles.add(@id1, %{x_vector: 10, y_vector: 10})

    #   Projectiles.tick()

    #   projectiles_list = Projectiles.list()

    #   assert %Projectile{x: 0, y: 0} = Enum.find(projectiles_list, &(&1.id === @id1))
    #   assert %Projectile{x: ^speed, y: ^speed} = Enum.find(projectiles_list, &(&1.id === @id2))
    # end
  end
end
