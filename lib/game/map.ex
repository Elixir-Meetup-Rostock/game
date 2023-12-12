defmodule Game.Map do
  @moduledoc """
  Holds the data of the map
  """

  use Agent

  alias Game.Map.Obstacle
  alias Game.Map.Spawn
  alias Game.Map.Sprite
  alias Game.Map.Tile

  # @dir Path.expand("../../priv/map", __DIR__)

  def start(name \\ __MODULE__) do
    Agent.start_link(fn -> Map.new() end, name: name)
  end

  def stop(name \\ __MODULE__), do: Agent.stop(name)

  def load(file, name \\ __MODULE__) do
    # {sprites, tiles, spawns, obstacles} =
    #   [@dir, file]
    #   |> Path.join()
    #   |> File.read!()
    #   |> Jason.decode!()
    #   |> create_structs()

    # TODO: Fix json file-loading or load map from database
    {sprites, tiles, spawns, obstacles} =
      get_fallback_map(file)
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

  defp get_fallback_map("test.json") do
    """
    {
      "sprites": [
        {
          "id": "grass",
          "src": "/images/sprites/grass.png"
        },
        {
          "id": "rock",
          "src": "/images/sprites/rock.png",
          "obstacle": true
        }
      ],
      "tiles": [
        {
          "sprite_id": "rock",
          "x": 0,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "rock",
          "x": 16,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "rock",
          "x": 32,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "rock",
          "x": 0,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 16,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "rock",
          "x": 32,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "rock",
          "x": 0,
          "y": 32,
          "z": 0
        },
        {
          "sprite_id": "rock",
          "x": 16,
          "y": 32,
          "z": 0
        },
        {
          "sprite_id": "rock",
          "x": 32,
          "y": 32,
          "z": 0
        }
      ],
      "spawns": [
        {
          "x": 16,
          "y": 16,
          "z": 0
        }
      ]
    }
    """
  end

  defp get_fallback_map("default.json") do
    """
    {
      "sprites": [
        {
          "id": "player_blue",
          "src": "/images/sprites/character_idle_blue.png",
          "frames": 4,
          "obstacle": true
        },
        {
          "id": "player_green",
          "src": "/images/sprites/character_idle_green.png",
          "frames": 4,
          "obstacle": true
        },
        {
          "id": "player_blue_walking",
          "src": "/images/sprites/character_walking_blue.png",
          "frames": 4,
          "obstacle": true
        },
        {
          "id": "player_green_walking",
          "src": "/images/sprites/character_walking_green.png",
          "frames": 4,
          "obstacle": true
        },
        {
          "id": "demo_tree",
          "src": "/images/sprites/demo_tree.png",
          "obstacle": true
        },
        {
          "id": "grass_1",
          "src": "/images/sprites/grass_1.png"
        },
        {
          "id": "grass_2",
          "src": "/images/sprites/grass_2.png"
        },
        {
          "id": "grass_flowers",
          "src": "/images/sprites/grass_flowers.png"
        },
        {
          "id": "grass",
          "src": "/images/sprites/grass.png"
        },
        {
          "id": "rock",
          "src": "/images/sprites/rock.png",
          "obstacle": true
        },
        {
          "id": "tree_stump_left",
          "src": "/images/sprites/tree_stump_left.png",
          "obstacle": true
        },
        {
          "id": "tree_stump_right",
          "src": "/images/sprites/tree_stump_right.png",
          "obstacle": true
        },
        {
          "id": "water_1",
          "src": "/images/sprites/water_1.png",
          "obstacle": true
        },
        {
          "id": "water_2",
          "src": "/images/sprites/water_2.png",
          "obstacle": true
        },
        {
          "id": "projectile",
          "src": "/images/sprites/projectile.png",
          "obstacle": true
        }
      ],
      "tiles": [
        {
          "sprite_id": "grass",
          "x": 80,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 80,
          "y": 80,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 32,
          "y": 32,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 0,
          "y": 64,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 64,
          "y": 80,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 16,
          "y": 80,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 96,
          "y": 96,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 96,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 32,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 48,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 16,
          "y": 32,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 0,
          "y": 48,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 64,
          "y": 48,
          "z": 0
        },
        {
          "sprite_id": "grass_flowers",
          "x": 16,
          "y": 48,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 32,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 80,
          "y": 48,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 80,
          "y": 96,
          "z": 0
        },
        {
          "sprite_id": "grass_flowers",
          "x": 48,
          "y": 32,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 0,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 48,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 80,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 48,
          "y": 48,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 16,
          "y": 96,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 48,
          "y": 96,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 32,
          "y": 96,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 48,
          "y": 64,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 0,
          "y": 96,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 16,
          "y": 64,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 64,
          "y": 96,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 32,
          "y": 48,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 64,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 32,
          "y": 80,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 96,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 48,
          "y": 80,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 64,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 16,
          "y": 0,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 0,
          "y": 32,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 64,
          "y": 32,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 96,
          "y": 80,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 96,
          "y": 64,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 80,
          "y": 64,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 16,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 96,
          "y": 48,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 0,
          "y": 16,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 32,
          "y": 64,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 0,
          "y": 80,
          "z": 0
        },
        {
          "sprite_id": "water_1",
          "x": 96,
          "y": 32,
          "z": 0
        },
        {
          "sprite_id": "rock",
          "x": 64,
          "y": 64,
          "z": 0
        },
        {
          "sprite_id": "grass",
          "x": 80,
          "y": 32,
          "z": 0
        }
      ],
      "spawns": [
        {
          "x": 16,
          "y": 16,
          "z": 0
        },
        {
          "x": 32,
          "y": 16,
          "z": 0
        },
        {
          "x": 16,
          "y": 32,
          "z": 0
        },
        {
          "x": 32,
          "y": 32,
          "z": 0
        }
      ]
    }
    """
  end
end
