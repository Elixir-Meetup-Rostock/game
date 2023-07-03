defmodule GameWeb.LobbyLiveTest do
  use GameWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "lobby_live" do
    test "renders the page with a form", %{conn: conn} do
      {:ok, lv, html} = conn |> live(~p"/lobby")

      assert html =~ "Lobby"
      assert has_element?(lv, "form")
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
