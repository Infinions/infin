defmodule InfinWeb.DashboardLive.Dashboard do
  use InfinWeb, :live_view

  alias Infin.Accounts

  @impl true
  def mount(_vars, %{"user_token" => user_token}, socket) do
    {:ok,
     assign(socket,
       company_id: Accounts.get_user_by_session_token(user_token).company_id,
       transactions_page_number: 0
     )}
  end

  @impl true
  def handle_info(:update, socket) do
    send_update(InfinWeb.DashboardLive.Cards,
      id: "#{socket.assigns.company_id}-cards",
      company_id: socket.assigns.company_id
    )

    {:noreply, socket}
  end

  def handle_info({:updated_transactions, transactions_page_number}, socket) do
    send_update(InfinWeb.DashboardLive.Pending,
      id: "#{socket.assigns.company_id}-pending",
      company_id: socket.assigns.company_id,
      transactions_page_number: transactions_page_number,
      invoices_page_number: 0
    )

    {:noreply,
     assign(socket, transactions_page_number: transactions_page_number)}
  end
end
