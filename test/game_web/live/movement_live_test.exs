defmodule GameWeb.MovementLiveTest do
  use GameWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Game.AccountsFixtures
  alias GameWeb.Presence

  setup do
    on_exit(fn ->
      for pid <- Presence.fetchers_pids() do
        ref = Process.monitor(pid)
        assert_receive {:DOWN, ^ref, _, _, _}, 1000
      end
    end)

    %{
      user: user_fixture()
    }
  end

  describe "movement_live" do
    test "renders the page with loading screen", %{conn: conn, user: user} do
      {:ok, lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/movement")

      assert html =~ ~s(<div id="loading")
      assert has_element?(lv, "div#loading")
    end

    test "show canvas when loading is completed", %{conn: conn, user: user} do
      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/movement")

      assert lv
             |> element("#sprites")
             |> render_hook(:sprites_loaded, %{}) =~ ~s(<canvas id="canvas")
    end

    test "redirect if user is not logged in", %{conn: conn} do
      {:error, {:redirect, to}} = live(conn, ~p"/movement")

      assert Map.get(to, :to) == ~p"/users/log_in"
      assert Map.get(to, :flash) == %{"error" => "You must log in to access this page."}
    end
  end
end
