defmodule Game.Board.Sprites do
  @moduledoc """
  Holds all different types of sprites
  """

  @dir "/images/sprites"

  def list() do
    [
      # %{key: "", file: "#{@dir}/character_idle_blue.png"},
      # %{key: "", file: "#{@dir}/character_idle_green.png"},
      # %{key: "", file: "#{@dir}/character_walking_blue.png"},
      # %{key: "", file: "#{@dir}/character_walking_green.png"},
      # %{key: "", file: "#{@dir}/demo_tree.png"},
      # %{key: "", file: "#{@dir}/grass_1.png"},
      # %{key: "", file: "#{@dir}/grass_2.png"},
      # %{key: "", file: "#{@dir}/grass_flowers.png"},
      %{key: "grass", file: "#{@dir}/grass.png"},
      %{key: "player", file: "#{@dir}/player.png"},
      %{key: "rock", file: "#{@dir}/rock.png"}
      # %{key: "", file: "#{@dir}/tree_stump_left.png"},
      # %{key: "", file: "#{@dir}/tree_stump_right.png"},
      # %{key: "", file: "#{@dir}/water_1.png"},
      # %{key: "", file: "#{@dir}/water_2.png"}
    ]
  end
end
