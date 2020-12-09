defmodule InfinWeb.DashboardLive.Dashboard do
  use InfinWeb, :live_view

  alias Infin.Accounts

  @impl true
  def mount(_vars, %{"user_token" => user_token}, socket) do
    {:ok, assign(socket, company_id: Accounts.get_user_by_session_token(user_token).company_id)}
  end

  @impl true
  def handle_info(:update, socket) do
    send_update(InfinWeb.DashboardLive.Cards, id: "#{socket.assigns.company_id}-cards", company_id: socket.assigns.company_id)

    {:noreply, socket}
  end
end
