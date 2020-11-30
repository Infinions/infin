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
    {:noreply, assign(socket, account: account)}
  end
end
