defmodule Infin.BankAccounts.PT.InvoiceTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "invoice_transactions" do
    belongs_to :transaction, Infin.BankAccounts.PT.Transaction, primary_key: true
    belongs_to :invoice, Infin.Invoices.Invoice, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:transaction_id, :invoice_id])
    |> validate_required([:transaction_id, :invoice_id])
  end
end
