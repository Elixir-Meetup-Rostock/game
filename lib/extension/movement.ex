defmodule Extension.Movement do
  @moduledoc """
  Calculates the new position from current position, move vector & speed
  """

  def move(position, _vector, 0), do: position

  def move({x, y} = _position, vector, speed) do
    angle = get_angle(vector)

    x_speed = round(speed * :math.cos(angle))
    y_speed = round(speed * :math.sin(angle))

    {x + x_speed, y + y_speed}
  end

  def get_angle({x, y}), do: get_angle({x, y}, :rad)
  def get_angle({x, y}, :rad), do: :math.atan2(y, x)
  def get_angle({x, y}, :deg), do: rad_to_deg(:math.atan2(y, x))

  def rad_to_deg(rad), do: rad * (180 / :math.pi())

  # defp deg_to_rad(deg), do: deg * (:math.pi() / 180)
end
