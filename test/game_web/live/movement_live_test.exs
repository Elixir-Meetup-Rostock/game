defmodule GameWeb.MovementLiveTest do
  use GameWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias GameWeb.Presence

  setup do
    on_exit(fn ->
      for pid <- Presence.fetchers_pids() do
        ref = Process.monitor(pid)
        assert_receive {:DOWN, ^ref, _, _, _}, 1000
      end
    end)
  end

  describe "movement_live" do
    test "renders the page with canvas", %{conn: conn} do
      params = %{user: %{name: "Lorem Ipsum"}}

      {:ok, lv, html} = conn |> live(~p"/movement?#{params}")

      assert html =~ ~s(<canvas id="game-canvas")
      assert has_element?(lv, "canvas#game-canvas")
    end

    test "redirect if user is not present", %{conn: conn} do
      assert {:error, redirect} = conn |> live(~p"/movement")

      assert {:redirect, %{to: path}} = redirect

      assert path === ~p"/lobby"
    end
  end
end
