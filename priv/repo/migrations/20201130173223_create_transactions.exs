defmodule Infin.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :transaction_id, :string
      add :creditor_name, :string
      add :amount, :string
      add :booking_date, :date
      add :value_date, :date
      add :remittance_information, :string
      add :account_id, references(:accounts)

      timestamps()
    end
  end
end
