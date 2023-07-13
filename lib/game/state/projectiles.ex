defmodule Game.State.Projectiles do
  @moduledoc """
  The state of the projectiles.
  """

  use Agent

  alias Game.State.Projectiles.Projectile

  def start do
    Agent.start_link(fn -> Map.new() end, name: __MODULE__)
  end

  def stop, do: Agent.stop(__MODULE__)

  def list() do
    Agent.get(__MODULE__, & &1)
    |> Map.values()
  end

  def add(id, %{x_vector: x, y_vector: y} = _data) do
    projectile = %Projectile{id: id, x_vector: x, y_vector: y}

    Agent.update(__MODULE__, &Map.put(&1, id, projectile))

    projectile
  end

  def remove(id) do
    Agent.update(__MODULE__, &Map.delete(&1, id))

    :ok
  end

  def tick() do
    Agent.update(__MODULE__, &tick_projectiles/1)
  end

  defp tick_projectiles(projectiles) do
    projectiles
    # remove projectiles that have no range left
    |> Enum.map(fn {id, projectile} -> {id, Projectile.tick(projectile)} end)
    |> Map.new()
  end
end
