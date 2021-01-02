defmodule Infin.BankAccounts.PT_Transactions do
  @moduledoc """
  The Banks.PT_Transactions context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.BankAccounts.PT.Bank
  alias Infin.BankAccounts.PT.Account
  alias Infin.BankAccounts.PT.Transaction
  alias Infin.BankAccounts.PT.InvoiceTransaction

  def list_pending_transactions(company_id, page_number) do
    account_ids =
      Account
      |> where(company_id: ^company_id)
      |> select([:id])
      |> Repo.all()
      |> Enum.map(& &1.id)

    Transaction
    |> where([t], t.account_id in ^account_ids and t.amount < 0)
    |> join(:left, [t], ti in InvoiceTransaction, on: t.id == ti.transaction_id)
    |> where([t, ti], is_nil(ti.transaction_id))
    |> Repo.paginate(page: page_number)
  end

  def list_debit_transactions(account_id, page_number) do
    transations = Transaction
    |> where([t], t.account_id == ^account_id and t.amount < 0)
    |> order_by([t], [desc: t.booking_date])
    |> Repo.paginate(page: page_number)

    entries = transations.entries
    |> Enum.map(fn t -> Map.put(t, :invoices, associated_invoices(t)) end)

    %{transations | entries: entries}
  end

  @spec fetch_transactions(any, any) :: [any]
  def fetch_transactions(account_id, start_date) do
    account = Repo.get(Account, account_id)

    bank =
      from(b in Bank, select: %{aspsp_cde: b.aspsp_cde})
      |> Repo.get(account.bank_id)

    fetch_transactions_from_api(account, bank.aspsp_cde, start_date)
    |> Enum.map(fn t -> upsert_transaction(account_id, t) end)
  end

  def update_transaction_status(iban, result) do
    account = Repo.get_by(Account, iban: iban)

    account =
      Ecto.Changeset.change(account, consent_status: result["transactionStatus"])

    Repo.update(account)
  end

  def fetch_transactions_from_api(account, aspsp_cde, start_date) do
    envs = Application.get_env(:infin, InfinWeb.Endpoint)[:pt_sibsapimarket]

    headers = %{
      "Date" => DateTime.utc_now() |> DateTime.to_iso8601(),
      "Content-type" => "application/json",
      "TPP-Transaction-ID" => "1",
      "TPP-Request-ID" => "1",
      "TPP-Certificate" => "1",
      "Signature" => "1",
      "Consent-ID" => account.consent_id,
      "X-IBM-Client-Id" => envs[:apiKey]
    }

    today = Date.utc_today() |> Date.to_iso8601()

    case HTTPoison.get(
           "#{envs[:url]}/#{aspsp_cde}/v1-0-3/accounts/#{account.api_id}/transactions?dateFrom=#{
             start_date
           }&dateTo=#{today}&bookingStatus=booked",
           headers
         ) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            {:ok, body} = {:ok, Jason.decode!(response.body)}
            body["transactions"]["booked"]

          _ ->
            {:err, Jason.decode!(response.body)}
        end

      _ ->
        {:err, "SIBS API Market is DOWN"}
    end
  end

  def upsert_transaction(account_id, transaction) do
    %Transaction{
      transaction_id: transaction["transactionId"],
      creditor_name: transaction["creditorName"],
      amount: transaction["amount"]["content"],
      booking_date: transaction["bookingDate"],
      value_date: transaction["valueDate"],
      remittance_information: transaction["remittanceInformationUnstructured"],
      account_id: account_id
    }
    |> Transaction.upsert_by_transaction_id(transaction["transactionId"])
  end

  def associate_invoice(transaction_id, invoice_id) do
    %InvoiceTransaction{
      transaction_id: transaction_id,
      invoice_id: invoice_id
    }
    |> Repo.insert()
  end

  ### PRIVATE ###

  defp associated_invoices(t) do
    InvoiceTransaction
    |> where(transaction_id: ^t.id)
    |> select([:invoice_id])
    |> Repo.all
    |> Enum.map(fn it -> it.invoice_id end)
  end
end
