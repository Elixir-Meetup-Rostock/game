defmodule Game.State.Players.Player do
  @moduledoc """

  """
  @derive Jason.Encoder

  @enforce_keys [:id, :name, :x, :y]

  defstruct [:id, :name, x: 0, y: 0, hp: 100]

  @type t :: %__MODULE__{}

  # defp get_color(name) do
  #   hue = name |> to_charlist() |> Enum.sum() |> rem(360)
  #   "hsl(#{hue}, 60%, 40%)"
  # end
end
