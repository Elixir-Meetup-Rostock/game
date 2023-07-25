defmodule Game.Map do
  @moduledoc """
  Holds all information about the map and it's tiles.
  """

  def list_sprites() do
    [
      %{key: "map", file: "/images/game_background.jpeg"},
      %{key: "player", file: "/images/player.png"}
    ]
  end
end
