defmodule InfinWeb.BankAccountPTLive.Index do
  use InfinWeb, :live_view

  alias Infin.BankAccounts.PT
  alias Infin.Accounts

  @impl true
  def mount(_vars, %{"user_token" => user_token}, socket) do
    company_id = Accounts.get_user_by_session_token(user_token).company_id
    assign(socket, company_id: company_id)

    return(:ok, socket, company_id, 0)
  end

  @impl true
  def handle_event("next_accounts", _value, socket) do
    if socket.assigns.current < socket.assigns.count do
      return(:noreply, socket, socket.assigns.company_id, socket.assigns.current + 1)
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("previous_accounts", _value, socket) do
    if socket.assigns.current > 0 do
      return(:noreply, socket, socket.assigns.company_id, socket.assigns.current - 1)
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("create_account", _values, socket) do
    {:noreply, push_redirect(socket, to: Routes.bank_account_pt_banks_path(socket, :index))}
  end

  @impl true
  def handle_event("open_account", %{"account_id" => account_id}, socket) do
    {:noreply,
     push_redirect(socket,
       to: Routes.bank_account_pt_accounts_path(socket, :index, id: account_id)
     )}
  end

  ### PRIVATE ###

  defp return(status, socket, company_id, page_number) do
    page = PT.list_accounts(company_id, page_number)

    {status,
     assign(socket, current: page.page_number, count: page.total_pages, accounts: page.entries)}
  end
end
