defmodule InfinWeb.BankAccountPTLive.Banks do
  use InfinWeb, :live_view
  alias Infin.BankAccounts.PT

  @impl true
  def mount(_params, _session, socket) do
    return(:ok, socket, 0)
  end

  @impl true
  def handle_event("next_bank", _value, socket) do
    if socket.assigns.current < socket.assigns.count do
      return(:noreply, socket, socket.assigns.current + 1)
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("previous_bank", _value, socket) do
    if socket.assigns.current > 0 do
      return(:noreply, socket, socket.assigns.current - 1)
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("select_bank", %{"aspspcde" => aspspcde}, socket) do
    {:noreply,
     push_redirect(socket,
       to: Routes.bank_account_pt_consents_path(socket, :index, aspspcde: aspspcde)
     )}
  end

  ### PRIVATE ###

  defp return(status, socket, page_number) do
    page = PT.list_banks(page_number)

    {status,
     assign(socket,
       current: page.page_number,
       count: page.total_pages,
       visible_banks: page.entries
     )}
  end
end
