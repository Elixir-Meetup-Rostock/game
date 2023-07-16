defmodule Game.State.Projectiles.ProjectileTest do
  use Game.DataCase, async: true

  alias Game.State.Projectiles.Projectile

  @id "random-id"

  describe "Projectile fields" do
    test "has nessessary fields" do
      projectile = %Projectile{id: @id, x_vector: 10, y_vector: 20}

      assert %Projectile{id: @id, x: 0, y: 0, x_vector: 10, y_vector: 20, speed: _, range: _} =
               projectile
    end
  end
end
