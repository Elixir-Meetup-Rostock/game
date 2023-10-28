defmodule Game.State.Obstacles do
  @moduledoc """
  Module for handling obstacles. Dummy implementation only
  """
  alias Game.State.Obstacles.Obstacle

  @default %{
    width: 16,
    height: 16
  }

  @spec list :: list(Game.State.Obstacles.Obstacle.t())
  def list() do
    Game.Board.get_obstacles()
    |> Enum.map(&struct(Obstacle, Map.merge(&1, @default)))
  end
end
