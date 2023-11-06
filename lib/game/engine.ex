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

  defp collide(go1, go1, acc), do: acc

  defp collide(go1, go2, acc) do
    if collides?(go1, go2) do
      acc
      |> add_collision(go1, go2)
      |> add_collision(go2, go1)
    else
      acc
    end
  end

  @doc """
  Detects all collisons ofthe given game object with game objects in the given list. Will not report collisions with itself.
  Returns a list of game object reference tuples or an empty list if no collisions were detected.
  """
  @spec detect_collisions_for_go(game_object(), list(game_object())) :: list(game_object())
  def detect_collisions_for_go(go, game_objects) do
    Enum.reduce(game_objects, [], fn x, acc ->
      if collides?(go, x), do: [x | acc], else: acc
    end)
  end

  @radius 20
  defp collides?(%{__struct__: s, id: id}, %{__struct__: s, id: id}), do: false

  defp collides?(go1, go2) do
    sqr_dist(go1, go2) < (2 * @radius) ** 2
  end

  defp sqr_dist(%{x: x1, y: y1}, %{x: x2, y: y2}) do
    (x1 - x2) ** 2 + (y1 - y2) ** 2
  end

  defp add_collision(acc, go1, go2) do
    acc |> Map.update(go_to_ref(go1), [go_to_ref(go2)], &[go_to_ref(go2) | &1])
  end

  @spec detect_hits(list(game_object()), list(game_object())) :: %{go_ref() => list(go_ref())}
  def detect_hits(hitters, targets) do
    hitters
    |> Enum.map(fn hitter -> {go_to_ref(hitter), detect_collisions_for_go(hitter, targets)} end)
    |> Map.new()
  end

  def go_to_ref(%{__struct__: type, id: id}), do: {type, id}

  @doc """
  Takes three game objects and compares the distance of the second and third object to the first. Returns :gt if the
  third object is further away than the second, :lt if its the other way around and :eq if both have the same distance
  to the first object.
  """
  @spec compare_distance(game_object(), game_object(), game_object()) :: :eq | :gt | :lt
  def compare_distance(go, old_state, new_state) do
    distance_old = sqr_dist(go, old_state)
    distance_new = sqr_dist(go, new_state)

    cond do
      distance_new < distance_old -> :lt
      distance_new > distance_old -> :gt
      true -> :eq
    end
  end

  @doc """
  Takes a list of game objects as well as two game objects. Returns true if at least one of the game objects
  in the list is further away from the second game object than the first and none of them are closer. Returns false
  otherwise.
  """
  @spec distance_increasing?(list(game_object()), game_object(), game_object()) :: boolean
  def distance_increasing?(game_objects, old_state, new_state) do
    dist_changes =
      game_objects
      |> Enum.map(&compare_distance(&1, old_state, new_state))

    Enum.member?(dist_changes, :gt) && !Enum.member?(dist_changes, :lt)
  end
end
