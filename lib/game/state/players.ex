defmodule Game.State.Players do
  @moduledoc """
  The state of the players.
  """

  use Agent

  def start do
    Agent.start_link(fn -> Map.new() end, name: __MODULE__)
  end

  def stop, do: Agent.stop(__MODULE__)

  def list_players(), do: Agent.get(__MODULE__, & &1)

  def add_player(id, data \\ nil) do
    # create player with data

    # add player
    Agent.update(__MODULE__, &Map.put(&1, id, data))

    # return player
  end

  def remove_player(_id) do
    # remove player
    # Agent.update(__MODULE__, &Map.put(&1, id, data))

    # return :ok
  end

  def get_player(id), do: Agent.get(__MODULE__, &Map.get(&1, id))
end
