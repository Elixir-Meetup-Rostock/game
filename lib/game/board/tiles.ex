defmodule Game.Board.Tiles do
  @moduledoc """
  Holds all different types of tiles
  """

  alias Game.Board.Tiles.Tile

  def list() do
    [
      %Tile{id: 1, sprite: "map", sprite_x: 216, sprite_y: 12},
      %Tile{id: 2, sprite: "map", sprite_x: 216, sprite_y: 108},
      %Tile{id: 9, sprite: "player", sprite_x: 0, sprite_y: 0, size: 395}
    ]
  end

  def get(id) do
    list()
    |> to_id_map()
    |> Map.get(id)
  end

  defp to_id_map(list) do
    list
    |> Enum.map(fn tile -> {tile.id, tile} end)
    |> Map.new()
  end
end
