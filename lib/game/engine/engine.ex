defmodule Game.Engine do
  @moduledoc """
  The Engine performs operations on the game state. Probably badly named and in the wrong place.
  """
  @type game_object :: %{x: integer(), y: integer()}

  @spec detect_collisions(list(game_object())) ::
          nil
          | %{
              {atom(), integer()} => list({atom(), integer()})
            }
  def detect_collisions(game_objects) do
    collisions = game_objects |> detect_collisions(%{})
    if Enum.empty?(collisions), do: nil, else: collisions
  end

  defp detect_collisions([], collisions), do: collisions

  defp detect_collisions([go | tail], collisions) do
    collisions =
      go
      |> detect_go_collision(tail)
      |> Map.merge(collisions, fn _key, v1, v2 -> v1 ++ v2 end)

    detect_collisions(tail, collisions)
  end

  defp detect_go_collision(go, game_objects) do
    game_objects
    |> Enum.reduce(%{}, fn x, acc -> collide(go, x, acc) end)
  end

  defp collide(go1, go2, acc) do
    if collides?(go1, go2) do
      acc
      |> add_collision(go1, go2)
      |> add_collision(go2, go1)
    else
      acc
    end
  end

  @radius 20
  defp collides?(%{x: x1, y: y1}, %{x: x2, y: y2}) do
    square_distance = (x1 - x2) ** 2 + (y1 - y2) ** 2

    square_distance < (2 * @radius) ** 2
  end

  defp add_collision(acc, %{__struct__: type1, id: id1}, %{__struct__: type2, id: id2}) do
    acc |> Map.update({type1, id1}, [{type2, id2}], &[{type2, id2} | &1])
  end
end
