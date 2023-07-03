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
  end

  #####

  # setup do
  #   {:ok, pid} = GenServer.start_link(MyApp.ScoreTableQueue, _init_args = nil)
  #   {:ok, queue: pid}
  # end

  # test "pushes value in the queue", %{queue: queue} do
  #   assert :ok == ScoreTableQueue.push(queue, [1,2,3,4])
  # end
end
