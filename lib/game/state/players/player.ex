defmodule Game.State.Players.Player do
  @moduledoc """
  This is the player itself with it's current state and specific actions.
  """

  @enforce_keys [:id, :name]

  @derive Jason.Encoder
  defstruct [
    :id,
    :name,
    x: 0,
    y: 0,
    hp: 100,
    speed: 1,
    actions: %{up: false, left: false, right: false, down: false, space: false}
  ]

  @type t :: %__MODULE__{}

  def set_action(%__MODULE__{} = player, action, state)
      when action in [:up, :left, :right, :down, :space] do
    put_in(player, [Access.key!(:actions), Access.key!(action)], state)
  end

  def set_action(%__MODULE__{} = player, _action, _state), do: player

  def tick(%__MODULE__{speed: 0} = player, _), do: player

  def tick(%__MODULE__{} = player, colliders),
    do: player |> move_y() |> move_x() |> maybe_move(player, colliders)

  defp move_y(%{actions: %{up: true, down: false}, speed: speed} = player) do
    player |> Map.update!(:y, &(&1 - speed))
  end

  defp move_y(%{actions: %{up: false, down: true}, speed: speed} = player) do
    Map.update!(player, :y, &(&1 + speed))
  end

  defp move_y(player), do: player

  defp move_x(%{actions: %{left: true, right: false}, speed: speed} = player) do
    Map.update!(player, :x, &(&1 - speed))
  end

  defp move_x(%{actions: %{left: false, right: true}, speed: speed} = player) do
    Map.update!(player, :x, &(&1 + speed))
  end

  defp move_x(player), do: player
  defp maybe_move(desired_state, desired_state, _colliders), do: desired_state

  defp maybe_move(desired_state, old_state, colliders) do
    Game.Engine.detect_collisions_for_go(desired_state, colliders)
    |> case do
      [] -> desired_state
      _ -> old_state
    end
  end

  # defp get_color(name) do
  #   hue = name |> to_charlist() |> Enum.sum() |> rem(360)
  #   "hsl(#{hue}, 60%, 40%)"
  # end
end
