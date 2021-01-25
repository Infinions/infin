defmodule InfinWeb.HomeController do
  use InfinWeb, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: Routes.dashboard_dashboard_path(conn, :index))
    else
      redirect(conn, to: Routes.user_registration_path(conn, :new))
    end
  end
end
