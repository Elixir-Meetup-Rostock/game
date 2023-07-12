defmodule Game.State.Players.Player do
  @moduledoc """

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

  def set_action(%__MODULE__{actions: %{up: true}} = player, :down, true) do
    put_in(player, [Access.key!(:actions), Access.key!(:up)], false)
  end

  def set_action(%__MODULE__{actions: %{left: true}} = player, :right, true) do
    put_in(player, [Access.key!(:actions), Access.key!(:left)], false)
  end

  def set_action(%__MODULE__{actions: %{right: true}} = player, :left, true) do
    put_in(player, [Access.key!(:actions), Access.key!(:right)], false)
  end

  def set_action(%__MODULE__{actions: %{down: true}} = player, :up, true) do
    put_in(player, [Access.key!(:actions), Access.key!(:down)], false)
  end

  def set_action(%__MODULE__{} = player, action, state)
      when action in [:up, :left, :right, :down, :space] do
    put_in(player, [Access.key!(:actions), Access.key!(action)], state)
  end

  def set_action(%__MODULE__{} = player, _action, _state), do: player

  def tick(%__MODULE__{speed: 0} = player), do: player

  def tick(%__MODULE__{actions: %{up: true}, speed: speed} = player) do
    Map.update!(player, :y, &(&1 - speed))
  end

  def tick(%__MODULE__{actions: %{left: true}, speed: speed} = player) do
    Map.update!(player, :x, &(&1 - speed))
  end

  def tick(%__MODULE__{actions: %{right: true}, speed: speed} = player) do
    Map.update!(player, :x, &(&1 + speed))
  end

  def tick(%__MODULE__{actions: %{down: true}, speed: speed} = player) do
    Map.update!(player, :y, &(&1 + speed))
  end

  def tick(%__MODULE__{} = player), do: player

  # defp get_color(name) do
  #   hue = name |> to_charlist() |> Enum.sum() |> rem(360)
  #   "hsl(#{hue}, 60%, 40%)"
  # end
end
