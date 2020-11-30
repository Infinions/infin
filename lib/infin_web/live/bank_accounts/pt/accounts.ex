defmodule InfinWeb.BankAccountPTLive.Accounts do
  use InfinWeb, :live_view

  alias Infin.BankAccounts.PT

  @impl true
  def mount(_vars, _url, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    account = PT.get_account(id)
    return(:noreply, socket, account, 0)
  end

  @impl true
  def handle_event("update_transactions", %{"transactions" => %{"start_date" => start_date}}, socket) do
    PT.fetch_transactions(socket.assigns.account.id, start_date)
    return(:noreply, socket, socket.assigns.account, 0)
  end

  @impl true
  def handle_event("next_transactions", _value, socket) do
    if socket.assigns.current < socket.assigns.count do
      return(:noreply, socket, socket.assigns.account, socket.assigns.current + 1)
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("previous_transactions", _value, socket) do
    if socket.assigns.current > 0 do
      return(:noreply, socket, socket.assigns.account, socket.assigns.current - 1)
    else
      {:noreply, socket}
    end
  end

  ### PRIVATE ###

  defp return(status, socket, account, page_number) do
    page = PT.list_transactions(account.id, page_number)

    {status, assign(socket, account: account, current: page.page_number, count: page.total_pages, transactions: page.entries)}
  end
end
