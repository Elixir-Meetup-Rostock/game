defmodule Game.State do
  @moduledoc """
  The state of the game.

  Does the game-tick and handles all state e.g. players, map, items.
  Calculates changes and invokes updates (if needed) on each tick.
  ____________________
  | FPS | tick_speed |
  | 25  | 40         |
  | 30  | 32         |
  | 60  | 16         |
  --------------------
  """

  use GenServer

  alias Game.State.Players
  alias Game.State.Projectiles
  alias Game.State.Obstacles
  alias Phoenix.PubSub

  @tick_speed 40
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
    Players.tick(list_obstacles())
    process_hits()

    PubSub.broadcast(Game.PubSub, @topic_tick, :tick)

    {:noreply, state}
  end

  def list_players() do
    Players.list()
  end

  def list_other_players(id) do
    list_players()
    |> Enum.reject(&(&1.id === id))
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

  def list_obstacles() do
    Players.list() ++ Obstacles.list()
  end

  def get_free_spawn() do
    {32, 32}
  end

  def process_hits() do
    hits = Game.Engine.detect_hits(Projectiles.list(), Players.list())

    for {_hitter, hits} <- hits do
      case hits do
        [] -> nil
        hits -> hits |> Enum.each(&puts_if_not_test("hit on " <> inspect(&1)))
      end
    end
  end

  defp puts_if_not_test(str) do
    if Mix.env() != :test do
      IO.puts(str)
    end
  end
end
