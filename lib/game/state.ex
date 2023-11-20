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

  alias Game.Map, as: GameMap
  alias Game.State.Players
  alias Game.State.Projectiles
  alias Phoenix.PubSub

  @tick_speed 40
  @topic_tick "tick"
  @map "default.json"

  def start_link(opts \\ []) do
    GameMap.start()
    Projectiles.start()
    Players.start()
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    GameMap.load(@map)

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
    data = data |> Map.put(:team, get_team_with_fewest_players())
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
    Players.list() ++ GameMap.list_obstacles()
  end

  def get_free_spawn() do
    spawns = Game.Board.list_spawns()
    players = Players.list()

    Enum.find(spawns, &is_free(&1, players))
    |> case do
      %{x: x, y: y} ->
        {x, y}

      _ ->
        puts_if_not_test("NO FREE SPAWN. Falling back")
        {32, 32}
    end
  end

  defp is_free(spawn, players) do
    spawn
    |> Game.Engine.detect_collisions_for_go(players)
    |> Kernel.==([])
  end

  def list_teams() do
    Players.list()
    # always add blue and green
    |> Enum.map(& &1.team)
    |> Enum.concat([:blue, :green])
    |> Enum.uniq()
  end

  defp get_team_with_fewest_players() do
    teams = list_teams()

    teams
    |> Enum.map(fn team -> {team, count_players(team)} end)
    |> Enum.sort_by(fn {_, count} -> count end)
    |> List.first()
    |> elem(0)
  end

  defp count_players(team) do
    Players.list()
    |> Enum.filter(fn player -> player.team == team end)
    |> Enum.count()
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
