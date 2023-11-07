defmodule Game.MapTest do
  use Game.DataCase, async: true

  alias Game.Map, as: GameMap
  alias Game.Map.Obstacle
  alias Game.Map.Spawn
  alias Game.Map.Sprite
  alias Game.Map.Tile

  @agent :map_test
  @map "test.json"

  describe "map Agent is automatically started" do
    test "has a pid and is running" do
      pid = Process.whereis(GameMap)

      refute pid === nil

      assert Process.alive?(pid) === true
    end
  end

  describe "map" do
    setup do
      {:ok, _pid} = GameMap.start(@agent)

      # Load test map
      GameMap.load(@map, @agent)
    end

    test "list_sprites returns sprites" do
      sprites = GameMap.list_sprites(@agent)

      assert is_list(sprites)
      assert length(sprites) === 2
      assert Enum.all?(sprites, &match?(%Sprite{}, &1))
    end

    test "list_tiles returns tiles" do
      tiles = GameMap.list_tiles(@agent)

      assert is_list(tiles)
      assert length(tiles) === 9
      assert Enum.all?(tiles, &match?(%Tile{}, &1))
    end

    test "list_spawns returns spawns" do
      spawns = GameMap.list_spawns(@agent)

      assert is_list(spawns)
      assert length(spawns) === 1
      assert Enum.all?(spawns, &match?(%Spawn{}, &1))
    end

    test "list_obstacles returns obstacles" do
      obstacles = GameMap.list_obstacles(@agent)

      assert is_list(obstacles)
      assert length(obstacles) === 8
      assert Enum.all?(obstacles, &match?(%Obstacle{}, &1))
    end
  end
end
