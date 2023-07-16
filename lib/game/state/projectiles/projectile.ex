defmodule Game.State.Projectiles.Projectile do
  @moduledoc """
  This is the projectile itself with it's current state and specific actions.
  """

  alias Extension.Movement

  @enforce_keys [:id]

  @derive Jason.Encoder
  defstruct [
    :id,
    x: 0,
    y: 0,
    x_vector: 0,
    y_vector: 0,
    speed: 10,
    range: 1000
  ]

  @type t :: %__MODULE__{}

  def tick(%__MODULE__{speed: 0} = projectile), do: projectile

  def tick(%__MODULE__{x: x, y: y, x_vector: xv, y_vector: yv, speed: s, range: r} = projectile) do
    {new_x, new_y} = Movement.move({x, y}, {xv, yv}, s)

    %{projectile | x: new_x, y: new_y, range: r - s}
  end
end
