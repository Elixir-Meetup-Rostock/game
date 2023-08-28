defmodule Game.Board.Sprites do
  @moduledoc """
  Holds all different types of sprites
  """

  @dir "/images/sprites"

  def list() do
    [
      %{key: "map", file: "#{@dir}/demo-sprite.png"},
      %{key: "player", file: "#{@dir}/player.png"}
    ]
  end
end
