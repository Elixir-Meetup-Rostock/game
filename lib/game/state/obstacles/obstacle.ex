defmodule Game.State.Obstacles.Obstacle do
  @moduledoc """
  This is a generic obstacle game object.
  """

  @enforce_keys [:id, :name]

  @derive Jason.Encoder
  defstruct [
    :id,
    :name,
    x: 0,
    y: 0,
    width: 0,
    height: 0
  ]

  @type t :: %__MODULE__{}
end
