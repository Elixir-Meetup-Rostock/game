defmodule Game.State do
  @moduledoc """
  The state of the game.

  Does the game-tick and handles all state e.g. players, map, items.
  Calculates changes and invokes updates (if needed) on each tick.
  """

  use GenServer

  alias Game.State.Players
  alias Game.State.Projectiles
  alias Phoenix.PubSub

  @tick_speed 16
  @topic_tick "tick"

  def start_link(opts \\ []) do
    Projectiles.start()
    Players.start()
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    :timer.send_interval(@tick_speed, self(), :tick)

    {:ok, %{}}
  end

  @impl true
  def handle_info(:tick, state) do
    Projectiles.tick()
    Players.tick()

    # probably not where we should do this
    Players.list()
    |> Game.Engine.detect_collisions()
    |> case do
      nil -> nil
      # IO.inspect(col)
      _col -> :coll
    end

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

  def list_projectiles() do
    Projectiles.list()
  end

  def add_projectile(player_id, vector) do
    %{id: id, x: x, y: y} = get_player(player_id)

    Projectiles.add(id, {x, y}, vector)
  end
end
