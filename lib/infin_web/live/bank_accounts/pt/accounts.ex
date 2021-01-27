defmodule InfinWeb.BankAccountPTLive.Accounts do
  use InfinWeb, :live_view

  alias Infin.Invoices
  alias Infin.BankAccounts.PT_Accounts
  alias Infin.BankAccounts.PT_Transactions
  alias Infin.Accounts

  @impl true
  def mount(_vars, %{"user_token" => user_token}, socket) do
    {:ok,
     assign(socket,
       company_id: Accounts.get_user_by_session_token(user_token).company_id
     )}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    account = PT_Accounts.get_account(socket.assigns.company_id, id)
    return(:noreply, socket, account, 0)
  end

  @impl true
  def handle_event(
        "update_transactions",
        %{"transactions" => %{"start_date" => start_date}},
        socket
      ) do
    PT_Transactions.fetch_transactions(socket.assigns.account.id, start_date)
    return(:noreply, socket, socket.assigns.account, 0)
  end

  @impl true
  def handle_event("next_transactions", _value, socket) do
    if socket.assigns.current < socket.assigns.count do
      return(
        :noreply,
        socket,
        socket.assigns.account,
        socket.assigns.current + 1
      )
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("previous_transactions", _value, socket) do
    if socket.assigns.current > 0 do
      return(
        :noreply,
        socket,
        socket.assigns.account,
        socket.assigns.current - 1
      )
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("back", _value, socket) do
    {:noreply,
     push_redirect(socket, to: Routes.bank_account_pt_index_path(socket, :index))}
  end

  @impl true
  def handle_event("delete", _value, socket) do
    PT_Accounts.delete_account(
      socket.assigns.company_id,
      socket.assigns.account.id
    )

    {:noreply,
     push_redirect(socket, to: Routes.bank_account_pt_index_path(socket, :index))}
  end

  @impl true
  def handle_event("show_invoice", value, socket) do
    {:noreply, assign(socket, invoice: Invoices.get_invoice_with_relations(value["id"]))}
  end

  @impl true
  def handle_event("hide_invoice", _value, socket) do
    {:noreply, assign(socket, invoice: nil)}
  end

  ### PRIVATE ###

  defp return(status, socket, account, page_number) do
    page = PT_Transactions.list_debit_transactions(account.id, page_number)

    {status,
     assign(socket,
       account: account,
       current: page.page_number,
       count: page.total_pages,
       transactions: page.entries
     )}
  end

  def parse_list(invoices) do
    case Enum.empty?(invoices) do
      false ->
        invoices
        |> Enum.map(fn i ->
          "<a class=\"invoice\" phx-click=\"show_invoice\" phx-value-id=\"#{i}\">#{i}</a>"
        end)
        |> Enum.join(", ")

      _ ->
        "-"
    end
  end

  def get_total_value(invoice) do
    Decimal.new(invoice.total_value) |> Decimal.div(100) |> Decimal.round(2)
  end
end
