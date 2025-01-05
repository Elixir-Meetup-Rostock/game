defmodule GameWeb.PageControllerTest do
  use GameWeb.ConnCase

  test "GET /example", %{conn: conn} do
    conn = get(conn, ~p"/example")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end
end
