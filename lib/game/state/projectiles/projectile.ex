defmodule Game.State.Projectiles.Projectile do
  @moduledoc """

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
    speed: 1,
    range: 100
  ]

  @type t :: %__MODULE__{}

  def tick(%__MODULE__{speed: 0} = projectile), do: projectile

  def tick(%__MODULE__{x: x, y: y, x_vector: xv, y_vector: yv, speed: s, range: r} = projectile) do
    # IO.inspect({x, y})

    {new_x, new_y} = Movement.move({x, y}, {xv, yv}, s)

    %{projectile | x: new_x, y: new_y, range: r - 1}
  end
end
