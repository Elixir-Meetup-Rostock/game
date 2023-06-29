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

  describe "players" do
    test "can add a player" do
      assert :ok = State.add_player("random-id", "lorem ipsum")
    end

    test "can list players" do
      player_id = "random-id"
      player_name = "lorem ipsum"

      State.add_player(player_id, player_name)

      assert %{players: %{^player_id => player}} = State.list_players()
      assert %{name: ^player_name} = player
    end
  end
end
