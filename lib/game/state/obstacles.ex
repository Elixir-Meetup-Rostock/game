defmodule Game.State.Obstacles do
  @moduledoc """
  Module for handling obstacles. Dummy implementation only
  """
  alias Game.State.Obstacles.Obstacle

  @spec list :: list(Game.State.Obstacles.Obstacle.t())
  def list() do
    [
      %Obstacle{id: "The first Stone", name: "Stone", x: -110, y: 120}
    ]
  end
end
