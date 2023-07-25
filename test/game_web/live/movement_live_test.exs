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
    test "renders the page with loading screen", %{conn: conn} do
      params = %{user: %{name: "Lorem Ipsum"}}

      {:ok, lv, html} = conn |> live(~p"/movement?#{params}")

      assert html =~ ~s(<div id="game-loading")
      assert has_element?(lv, "div#game-loading")
    end

    test "show canvas when loading is completed", %{conn: conn} do
      params = %{user: %{name: "Lorem Ipsum"}}

      {:ok, lv, _html} = conn |> live(~p"/movement?#{params}")

      assert lv
             |> element("#game-sprites")
             |> render_hook(:sprites_loaded, %{}) =~ ~s(<canvas id="game-canvas")
    end

    test "redirect if user is not present", %{conn: conn} do
      assert {:error, redirect} = conn |> live(~p"/movement")

      assert {:redirect, %{to: path}} = redirect

      assert path === ~p"/lobby"
    end
  end
end
