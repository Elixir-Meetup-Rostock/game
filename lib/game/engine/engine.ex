defmodule Game.Engine do
  @moduledoc """
  The Engine performs operations on the game state. Probably badly named and in the wrong place.
  """
  @type game_object :: %{
          x: integer(),
          y: integer(),
          __struct__: atom(),
          id: integer() | String.t()
        }

  @type go_ref :: {atom(), integer() | String.t()}

  @doc """
  Detects all collisions between game objects in the given list. Game objects can be any structs with an id and x/y coordinates.
  Mixing different game object structs (e.g. players and projectiles) is not a problem. Returns a map of all collisions for each
  game object. Game objects are represented as are tuples of the struct type and its id. e.g. `{Player, 2}`
  That means that ids should be unique per type of game object you are working with, but can be repeated between different types.

  ## Examples
      iex> defmodule Player do
             defstruct x: nil, y: nil, id: nil
           end
      iex> game_objects = [
              %Player{id: 1, x: 100, y: 100},
              %Player{id: 2, x: 120, y: 120},
              %Player{id: 3, x: 80, y: 80},
              %Player{id: 4, x: 120, y: 140}
           ]
      iex> detect_collisions(game_objects)
      %{
        {Player, 1} => [{Player, 3}, {Player, 2}],
        {Player, 2} => [{Player, 4}, {Player, 1}],
        {Player, 3} => [{Player, 1}],
        {Player, 4} => [{Player, 2}]
      }
  """
  @spec detect_collisions(list(game_object())) :: %{go_ref() => list(go_ref())} | nil
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
