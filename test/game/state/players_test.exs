defmodule Game.State.PlayersTest do
  use Game.DataCase, async: true

  alias Game.State.Players

  describe "Agent is automatically started" do
    test "has a pid and is running" do
      pid = Process.whereis(Players)

      refute pid === nil

      assert Process.alive?(pid) === true
    end
  end

  describe "players" do
    test "can list players" do
      assert %{} = Players.list_players()

      player1_id = "random-id-1"
      player1_data = %{name: "lorem ipsum 1"}
      player2_id = "random-id-2"
      player2_data = %{name: "lorem ipsum 2"}

      Players.add_player(player1_id, player1_data)
      Players.add_player(player2_id, player2_data)

      player_list = Players.list_players()

      assert %{^player1_id => ^player1_data} = player_list
      assert %{^player2_id => ^player2_data} = player_list
    end

    test "can add a player" do
      player_id = "random-id"
      player_data = %{name: "lorem ipsum"}

      assert :ok = Players.add_player(player_id, player_data)
    end

    test "can get a specific player" do
      player_id = "random-id"
      player_data = %{name: "lorem ipsum"}

      assert :ok = Players.add_player(player_id, player_data)
      assert ^player_data = Players.get_player(player_id)
    end
  end
end
