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
end
