defmodule Game.Map do
  @moduledoc """
  Holds the data of the map
  """

  use Agent

  alias Game.Map.Obstacle
  alias Game.Map.Spawn
  alias Game.Map.Sprite
  alias Game.Map.Tile

  @dir Path.expand("../../priv/map", __DIR__)

  def start(name \\ __MODULE__) do
    Agent.start_link(fn -> Map.new() end, name: name)
  end

  def stop(name \\ __MODULE__), do: Agent.stop(name)

  def load(file, name \\ __MODULE__) do
    {sprites, tiles, spawns, obstacles} =
      [@dir, file]
      |> Path.join()
      |> File.read!()
      |> Jason.decode!()
      |> create_structs()

    Agent.update(name, &Map.put(&1, :sprites, sprites))
    Agent.update(name, &Map.put(&1, :tiles, tiles))
    Agent.update(name, &Map.put(&1, :spawns, spawns))
    Agent.update(name, &Map.put(&1, :obstacles, obstacles))
  end

  def list_sprites(name \\ __MODULE__), do: list(:sprites, name)
  def list_tiles(name \\ __MODULE__), do: list(:tiles, name)
  def list_spawns(name \\ __MODULE__), do: list(:spawns, name)
  def list_obstacles(name \\ __MODULE__), do: list(:obstacles, name)

  defp list(key, name) do
    Agent.get(name, &Map.get(&1, key))
  end

  defp create_structs(%{"sprites" => s, "tiles" => t, "spawns" => w}) do
    sprites = Enum.map(s, &create_sprite/1)
    tiles = Enum.map(t, &create_tile/1)
    spawns = Enum.map(w, &create_spawn/1)
    obstacles = create_obstacles(sprites, tiles)

    {sprites, tiles, spawns, obstacles}
  end

  defp create_obstacles(sprites, tiles) do
    sprite_map =
      sprites
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(fn sprite -> {sprite.id, sprite} end)
      |> Map.new()

    tiles
    |> Enum.map(&Map.from_struct/1)
    |> Enum.map(fn tile -> Map.merge(tile, sprite_map[tile.sprite_id]) end)
    |> Enum.filter(&(&1.obstacle === true))
    |> Enum.map(&create_obstacle/1)
  end

  defp create_sprite(attrs) do
    %Sprite{} |> Sprite.changeset(attrs) |> Sprite.to_struct()
  end

  defp create_tile(%{"x" => x, "y" => y, "z" => z} = attrs) do
    id = ["map", x, y, z] |> Enum.join("_")
    attrs = Map.put(attrs, "id", id)

    %Tile{} |> Tile.changeset(attrs) |> Tile.to_struct()
  end

  defp create_spawn(attrs) do
    %Spawn{} |> Spawn.changeset(attrs) |> Spawn.to_struct()
  end

  defp create_obstacle(attrs) do
    %Obstacle{} |> Obstacle.changeset(attrs) |> Obstacle.to_struct()
  end
end
