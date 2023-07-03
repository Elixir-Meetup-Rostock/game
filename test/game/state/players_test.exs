defmodule Game.State.PlayersTest do
  use Game.DataCase, async: true

  alias Game.State.Players
  alias Game.State.Players.Player

  describe "Agent is automatically started" do
    test "has a pid and is running" do
      pid = Process.whereis(Players)

      refute pid === nil

      assert Process.alive?(pid) === true
    end
  end

  describe "players" do
    test "can list players" do
      player1 = %{id: "random-id-1", name: "lorem ipsum 1"}
      player2 = %{id: "random-id-2", name: "lorem ipsum 2"}

      Players.add_player(player1.id, player1)
      Players.add_player(player2.id, player2)

      player_list = Players.list_players()

      assert is_list(player_list)

      assert player_list |> Enum.find(&(&1.id === player1.id))
      assert player_list |> Enum.find(&(&1.id === player2.id))
    end

    test "add a player returns player" do
      player_id = "random-id"
      player_name = "lorem ipsum"

      assert %Player{id: ^player_id, name: ^player_name} =
               Players.add_player(player_id, %{id: player_id, name: player_name})
    end
  end
end
