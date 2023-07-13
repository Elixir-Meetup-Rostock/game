defmodule Game.State.Projectiles.Projectile do
  @moduledoc """

  """

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

  def tick(%__MODULE__{speed: _speed, range: range} = projectile) do
    # new_x = 10
    # new_y = 10

    %{projectile | range: range - 1}
  end
end
