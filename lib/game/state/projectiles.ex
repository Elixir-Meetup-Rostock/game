defmodule Game.State.Projectiles do
  @moduledoc """
  The state of the projectiles.
  """

  use Agent

  alias Ecto.UUID
  alias Game.State.Projectiles.Projectile

  def start do
    Agent.start_link(fn -> Map.new() end, name: __MODULE__)
  end

  def stop, do: Agent.stop(__MODULE__)

  def list() do
    Agent.get(__MODULE__, & &1)
    |> Map.values()
  end

  def add(player_id, {x, y}, {xv, yv}) do
    uuid = UUID.generate()

    projectile = %Projectile{
      id: uuid,
      player_id: player_id,
      x: x,
      y: y,
      x_vector: xv,
      y_vector: yv
    }

    Agent.update(__MODULE__, &Map.put(&1, uuid, projectile))

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
    |> remove_projectiles_with_no_range_left()
    |> Enum.map(fn {id, projectile} -> {id, Projectile.tick(projectile)} end)
    |> Map.new()
  end

  defp remove_projectiles_with_no_range_left(projectiles) do
    projectiles
    |> Enum.reject(fn {_id, %{range: range}} -> range === 0 end)
  end
end
