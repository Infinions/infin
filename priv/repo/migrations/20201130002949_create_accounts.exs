defmodule Infin.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :iban, :string
      add :consent_id, :string
      add :consent_status, :string
      add :api_id, :string
      add :name, :string
      add :currency, :string
      add :account_type, :string
      add :expected_balance, :string
      add :authorized_balance, :string
      add :bank_id, references(:banks)
      add :company_id, references(:companies)

      timestamps()
    end

    create unique_index(:accounts, :iban)
    create unique_index(:accounts, :api_id)
  end
end
