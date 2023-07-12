defmodule Game.State.Players do
  @moduledoc """
  The state of the players.
  """

  use Agent

  alias Game.State.Players.Player
  alias Phoenix.PubSub

  @topic_update "players_update"

  def start do
    Agent.start_link(fn -> Map.new() end, name: __MODULE__)
  end

  def stop, do: Agent.stop(__MODULE__)

  def list() do
    Agent.get(__MODULE__, & &1)
    |> Map.values()
  end

  def get(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  def add(id, %{name: name} = _data) do
    player = %Player{id: id, name: name, x: 0, y: 0}

    Agent.update(__MODULE__, &Map.put(&1, id, player))

    PubSub.broadcast(Game.PubSub, @topic_update, {:join, id, player})

    player
  end

  def remove(id) do
    Agent.update(__MODULE__, &Map.delete(&1, id))

    PubSub.broadcast(Game.PubSub, @topic_update, {:leave, id, nil})

    :ok
  end

  def set_action(id, action, status) do
    player = id |> get() |> Player.set_action(action, status)

    Agent.update(__MODULE__, &Map.put(&1, id, player))
  end

  def tick() do
    Agent.update(__MODULE__, &tick_players/1)
  end

  defp tick_players(players) do
    players
    |> Enum.map(fn {id, player} -> {id, Player.tick(player)} end)
    |> Map.new()
  end
end
