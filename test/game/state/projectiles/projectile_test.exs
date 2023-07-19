defmodule Game.State.Projectiles.ProjectileTest do
  use Game.DataCase, async: true

  alias Ecto.UUID
  alias Game.State.Projectiles.Projectile

  @player_id "random-id"

  describe "Projectile fields" do
    test "has nessessary fields" do
      uuid = UUID.generate()
      projectile = %Projectile{id: uuid, player_id: @player_id, x_vector: 10, y_vector: 20}

      assert %Projectile{id: ^uuid, player_id: @player_id} = projectile
      assert %Projectile{x: 0, y: 0, x_vector: 10, y_vector: 20} = projectile
      assert %Projectile{speed: _, range: _} = projectile
    end
  end

  describe "Projectile tick" do
    test "decrease projectile range" do
      uuid = UUID.generate()
      projectile1 = %Projectile{id: uuid, player_id: @player_id, x_vector: 10, y_vector: 20}
      projectile2 = Projectile.tick(projectile1)

      assert projectile1.range > projectile2.range
    end

    test "don't update projectile position when vector is 0,0" do
      uuid = UUID.generate()

      projectile =
        %Projectile{id: uuid, player_id: @player_id, x_vector: 0, y_vector: 0}
        |> Projectile.tick()

      assert %Projectile{x: 0, y: 0} = projectile
    end

    test "don't update projectile position when speed is 0" do
      uuid = UUID.generate()

      projectile =
        %Projectile{id: uuid, player_id: @player_id, x_vector: 10, y_vector: 10, speed: 0}
        |> Projectile.tick()

      assert %Projectile{x: 0, y: 0} = projectile
    end

    test "update position when speed and vector are not 0" do
      uuid = UUID.generate()

      projectile =
        %Projectile{id: uuid, player_id: @player_id, x_vector: 10, y_vector: 10}
        |> Projectile.tick()

      refute match?(%Projectile{x: 0, y: 0}, projectile)
    end
  end
end
