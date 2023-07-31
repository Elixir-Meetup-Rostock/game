defmodule Game.Board do
  @moduledoc """
  Holds all information about the board including the map and it's tiles.
  """

  alias Game.Board.Map
  alias Game.Board.Tile
  alias Game.State

  @sprites_dir "/images/sprites"

  def list_sprites() do
    [
      # %{key: "map", file: "#{@sprites_dir}/game_background.jpeg"},
      %{key: "map", file: "#{@sprites_dir}/demo-sprite.png"},
      %{key: "player", file: "#{@sprites_dir}/player.png"}
    ]
  end

  def get_tiles() do
    Map.get()
    |> Enum.with_index(fn row, y -> get_tiles({y, row}) end)
    |> List.flatten()
  end

  defp get_tiles({y, row}) do
    row
    |> Enum.with_index(fn _type, x -> %Tile{x: x, y: y} end)
  end

  def list_other_players(id) do
    State.list_players()
    |> Enum.reject(&(&1.id === id))
  end
end
