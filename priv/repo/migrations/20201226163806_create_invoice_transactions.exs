defmodule Infin.Repo.Migrations.CreateInvoiceTransactions do
  use Ecto.Migration

  def change do
    create table(:invoice_transactions, primary_key: false) do
      add :invoice_id, references(:invoices), primary_key: true
      add :transaction_id, references(:transactions), primary_key: true

      timestamps()
    end

    create unique_index(:invoice_transactions, [:invoice_id])
  end
end
