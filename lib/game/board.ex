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

  alias Game.Map, as: GameMap
  alias Game.State

  defdelegate list_spawns, to: GameMap, as: :list_spawns
  defdelegate list_sprites, to: GameMap, as: :list_sprites

  def get_layers(id) do
    [
      %{level: -2, tiles: GameMap.list_tiles()},
      %{level: -1, tiles: id |> State.list_other_players() |> get_tiles()},
      %{level: 0, tiles: []},
      %{level: 1, tiles: State.list_projectiles() |> get_tiles()}
    ]
  end

  def get_player(id) do
    id |> State.get_player() |> get_tile()
  end

  defp get_tiles(list), do: Enum.map(list, &get_tile/1)

  defp get_tile(%State.Players.Player{id: id, x: x, y: y, name: name}) do
    %{id: id, sprite_id: "player_blue", x: x, y: y, name: name}
  end

  defp get_tile(%State.Projectiles.Projectile{id: id, x: x, y: y}) do
    %{id: id, sprite_id: "projectile", x: x, y: y}
  end

  defp get_tile(_), do: nil
end
