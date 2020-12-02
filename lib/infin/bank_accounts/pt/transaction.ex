defmodule Infin.BankAccounts.PT.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Infin.BankAccounts.PT.Transaction
  alias Infin.Repo

  schema "transactions" do
    field :amount, :string
    field :booking_date, :date
    field :creditor_name, :string
    field :remittance_information, :string
    field :transaction_id, :string
    field :value_date, :date

    belongs_to :account, Infin.BankAccounts.PT.Account

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:transaction_id, :creditor_name, :amount, :booking_date, :value_date, :remittance_information, :account_id])
    |> validate_required([:transaction_id, :amount, :remittance_information, :account_id])
  end

  def upsert_by_transaction_id(transaction, transaction_id) do
    case Repo.get_by(Transaction, transaction_id: transaction_id) do
      nil -> %Transaction{}
      transaction -> transaction
    end
    |> Transaction.changeset(transaction |> Map.from_struct)
    |> Repo.insert_or_update
  end
end
