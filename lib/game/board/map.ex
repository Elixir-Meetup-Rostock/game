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
