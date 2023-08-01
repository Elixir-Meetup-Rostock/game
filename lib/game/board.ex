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
    |> Enum.map(&get/1)
  end

  defp get({{x, y}, type}) do
    type
    |> Tiles.get()
    |> Map.merge(%{x: x, y: y})
  end

  def list_other_players(id) do
    State.list_players()
    |> Enum.reject(&(&1.id === id))
  end
end
