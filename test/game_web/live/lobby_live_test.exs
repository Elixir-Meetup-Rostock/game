defmodule GameWeb.LobbyLiveTest do
  use GameWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "lobby" do
    test "renders the page", %{conn: conn} do
      {:ok, _lv, html} = conn |> live(~p"/lobby")

      assert html =~ "Lobby"
    end

    test "redirect to /cursor when name is set", %{conn: conn} do
      {:ok, lv, _html} = conn |> live(~p"/lobby")

      conn =
        lv
        |> form("form", user: %{name: "lorem ipsum"})
        |> submit_form(conn)

      assert conn.method == "GET"
      assert conn.params == %{"user" => %{"name" => "lorem ipsum"}}
    end
  end
end
