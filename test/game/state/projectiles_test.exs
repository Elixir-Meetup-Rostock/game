defmodule Game.State.ProjectilesTest do
  use Game.DataCase, async: true

  alias Game.State.Projectiles
  alias Game.State.Projectiles.Projectile

  @agent1 :projectiles_test_1
  @agent2 :projectiles_test_2

  describe "projectiles Agent is automatically started" do
    test "has a pid and is running" do
      pid = Process.whereis(Projectiles)

      refute pid === nil

      assert Process.alive?(pid) === true
    end
  end

  describe "projectiles state" do
    setup do
      {:ok, _pid} = Projectiles.start(@agent1)

      :ok
    end

    test "can list projectiles" do
      Projectiles.add("1", {0, 0}, {0, 0}, @agent1)

      projectiles_list = Projectiles.list(@agent1)

      assert is_list(projectiles_list)
      assert projectiles_list |> Enum.find(&(&1.player_id === "1"))
    end

    test "add projectile returns added projectile" do
      projectile = Projectiles.add("2", {0, 0}, {10, 10}, @agent1)

      assert %Projectile{player_id: "2", x_vector: 10, y_vector: 10} = projectile
    end
  end

  describe "projectiles tick" do
    setup do
      {:ok, _pid} = Projectiles.start(@agent2)

      :ok
    end

    test "remove projectiles with no range left" do
      %{range: range} = Projectiles.add("1", {0, 0}, {10, 10}, @agent2)

      assert Projectiles.list(@agent2) |> Enum.find(&(&1.player_id === "1"))

      ticks = range + 1
      Enum.each(1..ticks, fn _x -> Projectiles.tick(@agent2) end)

      refute Projectiles.list(@agent2) |> Enum.find(&(&1.player_id === "1"))
    end
  end
end
