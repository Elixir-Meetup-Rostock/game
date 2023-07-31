defmodule Game.Board do
  @moduledoc """
  Holds all information about the board including the map and it's tiles.
  """

  alias Game.Board.Map, as: BoardMap
  alias Game.Board.Tile
  alias Game.State

  @sprites_dir "/images/sprites"

  def list_sprites() do
    [
      %{key: "map", file: "#{@sprites_dir}/demo-sprite.png"},
      %{key: "player", file: "#{@sprites_dir}/player.png"}
    ]
  end

  def list_tiles() do
    %{
      0 => %Tile{id: 0, sprite: "map", sprite_x: 216, sprite_y: 12},
      1 => %Tile{id: 1, sprite: "map", sprite_x: 216, sprite_y: 108}
    }
  end

  def list_tiles_as_list() do
    list_tiles() |> Enum.map(fn {_, tile} -> tile end)
  end

  def find_tile(id), do: Map.get(list_tiles(), id)

  def get() do
    BoardMap.get()
    |> Enum.with_index(fn row, y -> get({y, row}) end)
    |> List.flatten()
  end

  defp get({y, row}) do
    row
    |> Enum.with_index(fn id, x -> get(id, x, y) end)
  end

  defp get(id, x, y) do
    find_tile(id) |> Map.merge(%{x: x, y: y})
  end

  def list_other_players(id) do
    State.list_players()
    |> Enum.reject(&(&1.id === id))
  end
end
