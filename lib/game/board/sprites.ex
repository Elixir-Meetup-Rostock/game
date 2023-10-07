defmodule Game.Board.Sprites do
  @moduledoc """
  Holds all different types of sprites
  """

  @dir "/images/sprites"

  def list() do
    [
      %{key: "player_blue", file: "#{@dir}/character_idle_blue.png", frames: 4},
      # %{key: "player_green", file: "#{@dir}/character_idle_green.png", frames: 4},
      # %{key: "", file: "#{@dir}/character_walking_blue.png", frames: 4},
      # %{key: "", file: "#{@dir}/character_walking_green.png", frames: 4},
      # %{key: "", file: "#{@dir}/demo_tree.png"},
      # %{key: "", file: "#{@dir}/grass_1.png"},
      # %{key: "", file: "#{@dir}/grass_2.png"},
      %{key: "grass_flowers", file: "#{@dir}/grass_flowers.png"},
      %{key: "grass", file: "#{@dir}/grass.png"},
      %{key: "rock", file: "#{@dir}/rock.png"},
      # %{key: "", file: "#{@dir}/tree_stump_left.png"},
      # %{key: "", file: "#{@dir}/tree_stump_right.png"},
      # %{key: "", file: "#{@dir}/water_1.png"},
      # %{key: "", file: "#{@dir}/water_2.png"}
      %{key: "projectile", file: "#{@dir}/projectile.png"}
    ]
  end
end
