defmodule Game.Board.Sprites do
  @moduledoc """
  Holds all different types of sprites
  """

  @dir "/images/sprites"

  def list() do
    [
      %{key: "grass", file: "#{@dir}/grass.png"},
      %{key: "rock", file: "#{@dir}/rock.png"},
      %{key: "player", file: "#{@dir}/player.png"}
    ]
  end
end
