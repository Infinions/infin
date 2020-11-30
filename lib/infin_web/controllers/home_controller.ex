defmodule InfinWeb.HomeController do
  use InfinWeb, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: "/manage/invoices")
    else
      render(conn, "index.html")
    end
  end
end
