defmodule Game.State do
  @moduledoc """
  The state of the game.

  Does the game-tick and handles all state e.g. players, map, items.
  Calculates changes and invokes updates (if needed) on each tick.
  """

  use GenServer

  alias Game.State.Players
  alias Phoenix.PubSub

  @tick_speed 16
  @topic_tick "tick"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)

    Players.start()
  end

  @impl true
  def init(_opts) do
    :timer.send_interval(@tick_speed, self(), :tick)

    {:ok, %{players: %{}}}
  end

  @impl true
  def handle_info(:tick, state) do
    Players.tick()

    PubSub.broadcast(Game.PubSub, @topic_tick, :tick)

    {:noreply, state}
  end

  def list_players() do
    Players.list()
  end

  def get_player(id) do
    Players.get(id)
  end

  def add_player(id, data) do
    Players.add(id, data)
  end

  def remove_player(id) do
    Players.remove(id)
  end

  def set_player_action(action, status, id) do
    Players.set_action(id, action, status)
  end
end
