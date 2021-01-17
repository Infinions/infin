alias Infin.BankAccounts.PT.Bank , as: PTBank
alias Infin.Repo

defmodule PTBankSeed do
  def fetch_banks do
    envs = Application.get_env(:infin, InfinWeb.Endpoint)[:pt_sibsapimarket]

    headers = %{
      "Content-type" => "application/json",
      "TPP-Transaction-ID" => "1",
      "TPP-Request-ID" => "1",
      "X-IBM-Client-Id" => envs[:apiKey]
    }

    case HTTPoison.get(
          envs[:url] <> "/v1/available-aspsp",
          headers
        ) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            {:ok, Jason.decode!(response.body)}

          _ ->
            {:err, Jason.decode!(response.body)}
        end

      _ ->
        {:err, "SIBS API Market is DOWN"}
    end
  end

  def insert_bank(bank) do
    Repo.insert(
      %PTBank{}
      |> PTBank.changeset(%{
        "bank_id" => bank["id"],
        "bic" => bank["bic"],
        "bank_code" => bank["bank-code"],
        "aspsp_cde" => bank["aspsp-cde"],
        "name" => bank["name"],
        "logo_location" => bank["logoLocation"]
      })
    )
  end
end

if PTBank |> Repo.aggregate(:count, :id) == 0 do
  {:ok, response} = PTBankSeed.fetch_banks
  response["aspsp-list"] |> Enum.map(fn x -> PTBankSeed.insert_bank(x) end)
end
