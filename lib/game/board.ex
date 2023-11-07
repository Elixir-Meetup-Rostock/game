defmodule Game.Board do
  @moduledoc """
  Holds all information to draw the current state of the board in the frontend.
  The board itself is structured in layers. Each Layer has a level (indicating it's z-index) and a list of tiles.
            _________
         __/        /
      __/ /        /
     / / /        /
    / / /________/<-- The foreground of the map (hightest level)
   / /________/<-- The layer with the player
  /________/<-- The background of the map (lowest level)

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
    %Tiles.Tile{id: "map_#{x}_#{y}", x: x, y: y, sprite: sprite}
  end

  defp get_tile(%State.Players.Player{id: id, name: name, x: x, y: y}) do
    %Tiles.Tile{id: id, name: name, x: x, y: y, sprite: "player_blue", frames: 4}
  end

  defp get_tile(%State.Projectiles.Projectile{id: id, x: x, y: y}) do
    %Tiles.Tile{id: id, x: x, y: y, sprite: "projectile"}
  end

  defp get_tile(_), do: nil

  @spec list_obstacles() :: [map()]
  defdelegate list_obstacles, to: BoardMap

  def list_spawns() do
    BoardMap.list_spawns()
    |> Enum.map(&struct(Tiles.Tile, &1))
  end
end
