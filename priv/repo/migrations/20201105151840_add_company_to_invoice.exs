defmodule Infin.Repo.Migrations.AddCompanyToInvoice do
  use Ecto.Migration

  def change do
    alter table("invoices") do
      add :company_seller_id, references(:companies)
      add :company_id, references(:companies)
    end

    create unique_index(:invoices, [:company_seller_id, :company_id])
  end
end
