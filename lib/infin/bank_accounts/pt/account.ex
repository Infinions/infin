defmodule Infin.BankAccounts.PT.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Infin.BankAccounts.PT.Account
  alias Infin.Repo

  schema "accounts" do
    field :account_type, :string
    field :api_id, :string
    field :consent_id, :string
    field :consent_status, :string
    field :currency, :string
    field :iban, :string
    field :name, :string
    field :authorized_balance, :string
    field :expected_balance, :string

    belongs_to :bank, Infin.BankAccounts.PT.Bank
    belongs_to :company, Infin.Companies.Company
    has_many :transactions, Infin.BankAccounts.PT.Transaction, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def from_consent_changeset(account, attrs) do
    account
    |> cast(attrs, [:iban, :consent_id, :consent_status, :bank_id, :company_id])
    |> validate_required([:iban, :consent_id, :consent_status, :bank_id, :company_id])
    |> unique_constraint([:iban])
  end

  @doc false
  def from_account_changeset(account, attrs) do
    account
    |> cast(attrs, [:iban, :api_id, :name, :currency, :account_type, :bank_id, :company_id])
    |> validate_required([:iban, :api_id, :name, :currency, :account_type, :authorized_balance, :expected_balance, :bank_id, :company_id])
    |> unique_constraint(:api_id)
    |> unique_constraint(:iban)
  end

  def upsert_by_iban(account, iban) do
    case Repo.get_by(Account, iban: iban) do
      nil -> %Account{}
      account -> account
    end
    |> Account.from_consent_changeset(account |> Map.from_struct)
    |> Repo.insert_or_update
  end
end
