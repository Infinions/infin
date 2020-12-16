defmodule InfinWeb.DashboardLive.Pending do
  use Phoenix.LiveComponent

  alias Infin.Invoices
  alias Infin.BankAccounts.PT

  @impl true
  def update(assigns, socket) do
    transactions_page =
      PT.list_pending_transactions(
        assigns.company_id,
        assigns.transactions_page_number
      )

    invoices_page =
      Invoices.list_company_invoices_unassociated(
        assigns.company_id,
        assigns.invoices_page_number
      )

    {:ok,
     assign(socket,
      company_id: assigns.company_id,
      transactions_page_number: transactions_page.page_number,
      transactions_count: transactions_page.total_pages,
      transactions: transactions_page.entries,
      invoices: invoices_page.entries
     )}
  end

  @impl true
  def handle_event("next_transactions", _value, socket) do
    page_number = socket.assigns.transactions_page_number
    count = socket.assigns.transactions_count

    if page_number < count do
      send(
        self(),
        {:updated_transactions, socket.assigns.transactions_page_number + 1}
      )
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("previous_transactions", _value, socket) do
    page_number = socket.assigns.transactions_page_number

    if page_number > 0 do
      send(
        self(),
        {:updated_transactions, socket.assigns.transactions_page_number - 1}
      )
    end

    {:noreply, socket}
  end

  def get_total_value(income) do
    if income.total_value do
      Decimal.new(income.total_value) |> Decimal.div(100) |> Decimal.round(2)
    else
      "0.00"
    end
  end
end
