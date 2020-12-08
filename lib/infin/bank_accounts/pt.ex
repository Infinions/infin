defmodule Infin.BankAccounts.PT do
  @moduledoc """
  The Banks.PT context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.BankAccounts.PT.Bank
  alias Infin.BankAccounts.PT.Account
  alias Infin.BankAccounts.PT.Transaction

  def list_banks(page_number) do
    Repo.paginate(Bank, page: page_number)
  end

  def list_accounts(company_id, page_number) do
    Account
    |> where(company_id: ^company_id)
    |> where([a], not is_nil(a.api_id))
    |> preload(:bank)
    |> Repo.paginate(page: page_number)
  end

  def get_account(company_id, account_id) do
    Repo.get_by(Account, company_id: company_id, id: account_id) |> Repo.preload([:bank])
  end

  def delete_account(company_id, account_id) do
    Repo.get_by(Account, company_id: company_id, id: account_id) |> Repo.delete!()
  end

  def fetch_account(aspsp_cde, iban, consent_id) do
    envs = Application.get_env(:infin, InfinWeb.Endpoint)[:pt_sibsapimarket]

    headers = %{
      "Date" => DateTime.utc_now() |> DateTime.to_iso8601(),
      "Content-type" => "application/json",
      "TPP-Transaction-ID" => "1",
      "TPP-Request-ID" => "1",
      "TPP-Certificate" => "1",
      "Signature" => "1",
      "Consent-ID" => consent_id,
      "X-IBM-Client-Id" => envs[:apiKey]
    }

    case HTTPoison.get(
           "#{envs[:url]}/#{aspsp_cde}/v1-0-3/accounts",
           headers
         ) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            {:ok, body} = {:ok, Jason.decode!(response.body)}
            search_account(aspsp_cde, iban, body)

          _ ->
            {:err, Jason.decode!(response.body)}
        end

      _ ->
        {:err, "SIBS API Market is DOWN"}
    end
  end

  def list_transactions(account_id, page_number) do
    Transaction |> where(account_id: ^account_id) |> Repo.paginate(page: page_number)
  end

  def fetch_transactions(account_id, start_date) do
    account = Repo.get(Account, account_id)
    bank = from(b in Bank, select: %{aspsp_cde: b.aspsp_cde}) |> Repo.get(account.bank_id)

    fetch_transactions_from_api(account, bank.aspsp_cde, start_date)
    |> Enum.map(fn t -> upsert_transaction(account_id, t) end)
  end

  def get_consent(aspsp_cde, iban, consent_id) do
    envs = Application.get_env(:infin, InfinWeb.Endpoint)[:pt_sibsapimarket]

    headers = %{
      "Date" => DateTime.utc_now() |> DateTime.to_iso8601(),
      "Content-type" => "application/json",
      "TPP-Transaction-ID" => "1",
      "TPP-Request-ID" => "1",
      "TPP-Certificate" => "1",
      "Signature" => "1",
      "X-IBM-Client-Id" => envs[:apiKey]
    }

    case HTTPoison.get(
           "#{envs[:url]}/#{aspsp_cde}/v1-0-3/consents/#{consent_id}/status",
           headers
         ) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            {:ok, body} = {:ok, Jason.decode!(response.body)}
            update_transaction_status(iban, body)

          _ ->
            {:err, Jason.decode!(response.body)}
        end

      _ ->
        {:err, "SIBS API Market is DOWN"}
    end
  end

  def create_consent(company_id, iban, aspsp_cde) do
    envs = Application.get_env(:infin, InfinWeb.Endpoint)[:pt_sibsapimarket]

    headers = %{
      "Date" => DateTime.utc_now() |> DateTime.to_iso8601(),
      "Content-type" => "application/json",
      "TPP-Transaction-ID" => "1",
      "TPP-Request-ID" => "1",
      "TPP-Certificate" => "1",
      "Signature" => "1",
      "Digest" => "1",
      "X-IBM-Client-Id" => envs[:apiKey]
    }

    body = %{
      "access" => %{
        "balances" => [
          %{"iban" => iban}
        ],
        "transactions" => [
          %{"iban" => iban}
        ]
      },
      "recurringIndicator" => false,
      "validUntil" => "2099-01-01T00:00:00Z",
      "frequencyPerDay" => 1,
      "combinedServiceIndicator" => false
    }

    case HTTPoison.post(
           "#{envs[:url]}/#{aspsp_cde}/v1-0-3/consents?tppRedirectPreferred=false",
           Jason.encode!(body),
           headers
         ) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            {:ok, body} = {:ok, Jason.decode!(response.body)}
            bank = get_bank(aspsp_cde)
            create_account(company_id, iban, bank.id, body)

          _ ->
            {:err, Jason.decode!(response.body)}
        end

      _ ->
        {:err, "SIBS API Market is DOWN"}
    end
  end

  ### PRIVATE ###

  defp get_bank(aspsp_cde) do
    Repo.get_by(Bank, aspsp_cde: aspsp_cde)
  end

  defp search_account(aspsp_cde, iban, body) do
    case body["accountList"] |> Enum.find(fn x -> x["iban"] == iban end) do
      nil -> {:err, "Account does not exist"}
      api_account -> update_account(aspsp_cde, api_account)
    end
  end

  defp create_account(company_id, iban, bank_id, body) do
    %Account{
      iban: iban,
      consent_id: body["consentId"],
      consent_status: body["transactionStatus"],
      bank_id: bank_id,
      company_id: company_id
    }
    |> Account.upsert_by_iban(iban)
  end

  defp update_account(aspsp_cde, api_account) do
    account = Repo.get_by(Account, iban: api_account["iban"])

    {expected, authorized} = get_balance(aspsp_cde, api_account["id"], account.consent_id)

    account =
      Ecto.Changeset.change(account,
        api_id: api_account["id"],
        name: api_account["name"],
        currency: api_account["currency"],
        account_type: api_account["accountType"],
        authorized_balance: authorized,
        expected_balance: expected
      )

    Repo.update(account)
  end

  defp update_transaction_status(iban, result) do
    account = Repo.get_by(Account, iban: iban)
    account = Ecto.Changeset.change(account, consent_status: result["transactionStatus"])
    Repo.update(account)
  end

  defp get_balance(aspsp_cde, account_id, consent_id) do
    envs = Application.get_env(:infin, InfinWeb.Endpoint)[:pt_sibsapimarket]

    headers = %{
      "Date" => DateTime.utc_now() |> DateTime.to_iso8601(),
      "Content-type" => "application/json",
      "TPP-Transaction-ID" => "1",
      "TPP-Request-ID" => "1",
      "TPP-Certificate" => "1",
      "Signature" => "1",
      "Consent-ID" => consent_id,
      "X-IBM-Client-Id" => envs[:apiKey]
    }

    case HTTPoison.get(
           "#{envs[:url]}/#{aspsp_cde}/v1-0-3/accounts/#{account_id}/balances",
           headers
         ) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            {:ok, body} = {:ok, Jason.decode!(response.body)}
            balance = get_in(body["balances"], [Access.at(0)])
            expected = balance["expected"]["amount"]["content"]
            authorized = balance["expected"]["amount"]["content"]
            {expected, authorized}

          _ ->
            {:err, Jason.decode!(response.body)}
        end

      _ ->
        {:err, "SIBS API Market is DOWN"}
    end
  end

  defp fetch_transactions_from_api(account, aspsp_cde, start_date) do
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

  defp upsert_transaction(account_id, transaction) do
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
end
