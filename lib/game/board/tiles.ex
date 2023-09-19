defmodule Game.Board.Tiles do
  @moduledoc """
  Holds all different types of tiles
  """

  alias Game.Board.Tiles.Tile

  def list() do
    [
      %Tile{id: 1, sprite: "grass"},
      %Tile{id: 2, sprite: "rock"},
      %Tile{id: 9, sprite: "player"}
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
