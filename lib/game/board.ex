defmodule Game.Board do
  @moduledoc """
  Holds all information about the map and it's tiles.
  """

  @sprites_dir "/images/sprites"

  def list_sprites() do
    [
      # %{key: "map", file: "#{@sprites_dir}/game_background.jpeg"},
      %{key: "map", file: "#{@sprites_dir}/demo-sprite.png.png"},
      %{key: "player", file: "#{@sprites_dir}/player.png"}
    ]
  end

  def get_map() do
    [
      [1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1]
    ]
  end
end
