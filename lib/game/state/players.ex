defmodule Game.State.Players do
  @moduledoc """
  The state of the players.
  """

  use Agent

  alias Game.State.Players.Player
  alias Game.Engine
  alias Phoenix.PubSub

  @topic_update "players_update"

  def start(name \\ __MODULE__) do
    Agent.start_link(fn -> Map.new() end, name: name)
  end

  def stop(name \\ __MODULE__), do: Agent.stop(name)

  def list(name \\ __MODULE__) do
    Agent.get(name, & &1) |> Map.values()
  end

  def get(id, name \\ __MODULE__) do
    Agent.get(name, &Map.get(&1, id))
  end

  def add(id, data, name \\ __MODULE__) do
    player =
      data
      |> Map.put(:id, id)
      |> then(&struct(Player, &1))

    Agent.update(name, &Map.put(&1, id, player))

    PubSub.broadcast(Game.PubSub, @topic_update, {:join, id, player})

    player
  end

  def remove(id, name \\ __MODULE__) do
    Agent.update(name, &Map.delete(&1, id))

    PubSub.broadcast(Game.PubSub, @topic_update, {:leave, id, nil})

    :ok
  end

  def set_action(id, action, status, name \\ __MODULE__) do
    player = id |> get(name) |> Player.set_action(action, status)

    Agent.update(name, &Map.put(&1, id, player))
  end

  @doc """
  Updates all players, handling movement. Takes a list of movement blocking colliders
  """
  @spec tick(list(Engine.game_object())) :: :ok
  def tick(colliders, name \\ __MODULE__) do
    Agent.update(name, fn state -> tick_players(state, colliders) end)
  end

  defp tick_players(players, colliders) do
    players
    |> Enum.map(fn {id, player} -> {id, Player.tick(player, colliders)} end)
    |> Map.new()
  end
end
