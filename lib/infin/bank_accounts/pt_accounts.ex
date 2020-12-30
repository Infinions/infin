defmodule Infin.BankAccounts.PT_Accounts do
  @moduledoc """
  The Banks.PT_Accounts context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.BankAccounts.PT.Account

  alias Infin.BankAccounts.PT_Banks
  alias Infin.BankAccounts.PT_Transactions

  def list_accounts(company_id, page_number) do
    Account
    |> where(company_id: ^company_id)
    |> where([a], not is_nil(a.api_id))
    |> preload(:bank)
    |> Repo.paginate(page: page_number)
  end

  def get_account(company_id, account_id) do
    Repo.get_by(Account, company_id: company_id, id: account_id)
    |> Repo.preload([:bank])
  end

  def delete_account(company_id, account_id) do
    Repo.get_by(Account, company_id: company_id, id: account_id)
    |> Repo.delete!()
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

  def search_account(aspsp_cde, iban, body) do
    case body["accountList"] |> Enum.find(fn x -> x["iban"] == iban end) do
      nil -> {:err, "Account does not exist"}
      api_account -> update_account(aspsp_cde, api_account)
    end
  end

  def create_account(company_id, iban, bank_id, body) do
    %Account{
      iban: iban,
      consent_id: body["consentId"],
      consent_status: body["transactionStatus"],
      bank_id: bank_id,
      company_id: company_id
    }
    |> Account.upsert_by_iban(iban)
  end

  def update_account(aspsp_cde, api_account) do
    account = Repo.get_by(Account, iban: api_account["iban"])

    {expected, authorized} =
      get_balance(aspsp_cde, api_account["id"], account.consent_id)

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

  def get_balance(aspsp_cde, account_id, consent_id) do
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
            bank = PT_Banks.get_bank(aspsp_cde)
            create_account(company_id, iban, bank.id, body)

          _ ->
            {:err, Jason.decode!(response.body)}
        end

      _ ->
        {:err, "SIBS API Market is DOWN"}
    end
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
            PT_Transactions.update_transaction_status(iban, body)

          _ ->
            {:err, Jason.decode!(response.body)}
        end

      _ ->
        {:err, "SIBS API Market is DOWN"}
    end
  end
end
