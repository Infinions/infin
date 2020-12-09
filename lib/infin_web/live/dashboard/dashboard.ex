defmodule InfinWeb.DashboardLive.Dashboard do
  use InfinWeb, :live_view

  @impl true
  def mount(_vars, _value, socket) do
    {:ok, socket}
  end
end
