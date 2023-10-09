defmodule Game.Board do
  @moduledoc """
  Holds all information to draw the board.
  Here a player becomes a drawable tile with a layer, a position and a sprite.
  """

  alias Game.Board.Map, as: BoardMap
  alias Game.Board.Sprites
  alias Game.Board.Tiles
  alias Game.State

  defdelegate list_sprites, to: Sprites, as: :list

  def get_layers(id) do
    [
      %{level: -2, tiles: BoardMap.get()},
      %{level: -1, tiles: State.list_other_players(id)},
      %{level: 0, tiles: []},
      %{level: 1, tiles: State.list_projectiles()}
    ]
    |> Enum.map(&get_tiles_for_layer/1)
  end

  def get_player(id) do
    id |> State.get_player() |> get_tile()
  end

  defp get_tiles_for_layer(layer) do
    Map.update!(layer, :tiles, &get_tiles/1)
  end

  defp get_tiles(list) do
    list
    |> Enum.map(&get_tile/1)
  end

  defp get_tile({{x, y}, sprite}) do
    size = 16

    %Tiles.Tile{id: "map_#{x}_#{y}", x: x * size, y: y * size, sprite: sprite}
  end

  defp get_tile(%State.Players.Player{id: id, x: x, y: y}) do
    %Tiles.Tile{id: id, x: x, y: y, sprite: "player_blue", frames: 4}
  end

  defp get_tile(%State.Projectiles.Projectile{id: id, x: x, y: y}) do
    %Tiles.Tile{id: id, x: x, y: y, sprite: "projectile"}
  end

  defp get_tile(_), do: nil
end
