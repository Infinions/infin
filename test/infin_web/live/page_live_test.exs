defmodule InfinWeb.PageLiveTest do
  use InfinWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Update"
    assert render(page_live) =~ "Update"
  end
end
