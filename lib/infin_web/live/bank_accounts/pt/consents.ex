defmodule InfinWeb.BankAccountPTLive.Consents do
  use InfinWeb, :live_view

  alias Infin.BankAccounts.PT

  @impl true
  def mount(_vars, _url, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"aspspcde" => aspspcde, "error_message" => error_message}, _url, socket) do
    {:noreply, assign(socket, bank: aspspcde, error_message: error_message)}
  end

  @impl true
  def handle_params(%{"aspspcde" => aspspcde}, _url, socket) do
    {:noreply, assign(socket, bank: aspspcde)}
  end

  @impl true
  def handle_event("save", %{"consent" => consent}, socket) do
    iban = remove_white_spaces(consent["iban"])

    if !validate_iban(iban) do
      {:noreply, assign(socket, error_message: "IBAN is not in the right format")}
    else
      if connected?(socket), do: Process.send_after(self(), :verify, 3000)
      {:noreply, assign(socket, iban: iban, done: true)}
    end
  end

  @impl true
  def handle_event("previous", _params, socket) do
    {:noreply, push_redirect(socket, to: Routes.bank_account_pt_banks_path(socket, :index))}
  end

  @impl true
  def handle_info(:verify, socket) do
    Process.send_after(self(), :verify, 3000)

    if socket.assigns[:account] do
      {:ok, account} = PT.get_consent(socket.assigns.bank, socket.assigns.account.iban, socket.assigns.account.consent_id)
      verify_consent(socket, account)
    else
      {:ok, account} = PT.create_consent(socket.assigns.iban, socket.assigns.bank)
      {:noreply, assign(socket, account: account)}
    end
  end

  ### PRIVATE ###

  defp verify_consent(socket, account) do
    if account.consent_status == "ACCP" do
      case PT.fetch_account(socket.assigns.bank, account.iban, account.consent_id) do
        {:ok, account} -> {:noreply, push_redirect(socket, to: Routes.bank_account_pt_accounts_path(socket, :index, id: account.id))}
        {_, error} -> {:noreply, assign(socket, account: account, done: false, error_message: error)}
      end
    else
      {:noreply, assign(socket, account: account, done: false)}
    end
  end

  defp remove_white_spaces(iban) do
    String.replace(iban, " ", "")
  end

  defp validate_iban(iban) do
    String.match?(iban, ~r/^[A-Z]{2,2}[0-9]{2,2}[a-zA-Z0-9]{1,30}$/)
  end
end
