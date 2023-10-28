defmodule Game.State.PlayersTest do
  use Game.DataCase, async: true

  alias Game.State.Players
  alias Game.State.Players.Player

  @agent1 :players_test_1
  @agent2 :players_test_2

  describe "players Agent is automatically started" do
    test "has a pid and is running" do
      pid = Process.whereis(Players)

      refute pid === nil

      assert Process.alive?(pid) === true
    end
  end

  describe "players state" do
    setup do
      {:ok, _pid} = Players.start(@agent1)

      :ok
    end

    test "can list players" do
      Players.add("1", %{name: "one"}, @agent1)

      player_list = Players.list(@agent1)

      assert is_list(player_list)
      assert player_list |> Enum.find(&(&1.id === "1"))
    end

    test "add player returns added player" do
      assert %Player{id: "2", name: "two"} = Players.add("2", %{name: "two"}, @agent1)
    end

    test "can set & unset action" do
      Players.add("3", %{name: "three"}, @agent1)

      Players.set_action("3", :up, true, @agent1)
      assert %Player{actions: %{up: true}} = Players.get("3", @agent1)

      Players.set_action("3", :up, false, @agent1)
      assert %Player{actions: %{up: false}} = Players.get("3", @agent1)
    end
  end

  describe "players tick" do
    setup do
      {:ok, _pid} = Players.start(@agent2)

      :ok
    end

    test "update player positions" do
      Players.add("1", %{name: "one", x: 0, y: 0}, @agent2)
      %{speed: speed} = Players.add("2", %{name: "two", x: 0, y: 0}, @agent2)

      Players.set_action("2", :down, true, @agent2)
      Players.tick([], @agent2)

      assert %Player{x: 0, y: 0} = Players.get("1", @agent2)
      assert %Player{x: 0, y: ^speed} = Players.get("2", @agent2)
    end

    test "don't move if obstacle is in the way" do
      Players.add("3", %{name: "three", x: 0, y: 16}, @agent2)
      Players.add("4", %{name: "four", x: 0, y: 0}, @agent2)

      Players.set_action("4", :down, true, @agent2)
      Players.tick(Players.list(@agent2), @agent2)

      assert %Player{x: 0, y: 16} = Players.get("3", @agent2)
      assert %Player{x: 0, y: 0} = Players.get("4", @agent2)
    end

    test "moving away from obstacle is fine" do
      Players.add("5", %{name: "five", y: 16, x: 0}, @agent2)
      %{speed: speed} = Players.add("6", %{name: "six", y: 0, x: 0}, @agent2)
      speed = speed * -1

      Players.set_action("6", :up, true, @agent2)
      Players.tick(Players.list(@agent2), @agent2)

      assert %Player{x: 0, y: 16} = Players.get("5", @agent2)
      assert %Player{x: 0, y: ^speed} = Players.get("6", @agent2)
    end

    test "can move away when stuck in an object" do
      Players.add("7", %{name: "seven", y: 8, x: 0}, @agent2)
      %{speed: speed} = Players.add("8", %{name: "eight", x: 0, y: 0}, @agent2)
      speed = speed * -1

      Players.set_action("8", :up, true, @agent2)
      Players.tick(Players.list(@agent2), @agent2)

      assert %Player{x: 0, y: 8} = Players.get("7", @agent2)
      assert %Player{x: 0, y: ^speed} = Players.get("8", @agent2)
    end
  end
end
