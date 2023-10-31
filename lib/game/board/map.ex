defmodule Game.Board.Map do
  @moduledoc """
  Holds the data of the map
  """

  @dir Path.expand("../../../priv/map", __DIR__)

  def get() do
    load()
    |> Enum.map(fn %{"x" => x, "y" => y, "sprite" => sprite} -> {{x, y}, sprite} end)
    |> Map.new()
  end

  @doc """
  Load all tiles marked with obstacle: true from the map.
  Somewhat expensive.
  """
  @spec list_obstacles() :: list(map())
  def list_obstacles() do
    load()
    |> Enum.filter(& &1["obstacle"])
    |> Enum.map(fn %{"x" => x, "y" => y} -> %{x: x, y: y} end)
  end

  @doc """
  Load all tiles that are legal spawns fromn the map.
  Somewhat expensive.
  """
  @spec list_spawns() :: list(map())
  def list_spawns() do
    load()
    |> Enum.filter(&(!&1["obstacle"]))
    |> Enum.map(fn %{"x" => x, "y" => y} -> %{x: x, y: y} end)
  end

  # def set(map) do
  #   body =
  #     get()
  #     |> Enum.map(fn {{x, y}, sprite} -> %{x: x, y: y, sprite: sprite} end)

  #   store(body)
  # end

  defp load() do
    [@dir, "default.json"]
    |> Path.join()
    |> File.read!()
    |> Jason.decode!()
  end

  # defp store(map) do
  #   body = Jason.encode!(map)

  #   [@dir, "default.json"]
  #   |> Path.join()
  #   |> File.write(body)
  # end
end
