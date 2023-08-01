defmodule Game.Board do
  @moduledoc """
  Holds all information about the board including the map and it's tiles.
  """

  alias Game.Board.Map, as: BoardMap
  alias Game.Board.Sprites
  alias Game.Board.Tiles
  alias Game.State

  defdelegate list_sprites, to: Sprites, as: :list

  defdelegate list_tiles, to: Tiles, as: :list

  def get() do
    BoardMap.get()
    |> Enum.with_index(fn row, y -> get({y, row}) end)
    |> List.flatten()
  end

  defp get({y, row}) do
    row
    |> Enum.with_index(fn type, x -> get(type, x, y) end)
  end

  defp get(type, x, y) do
    Tiles.get(type) |> Map.merge(%{x: x, y: y})
  end

  def list_other_players(id) do
    State.list_players()
    |> Enum.reject(&(&1.id === id))
  end
end
