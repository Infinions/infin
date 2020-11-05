defmodule Infin.Repo.Migrations.AddCompanyToInvoice do
  use Ecto.Migration

  def change do
    alter table("invoices") do
      add :company_seller_id, references(:companies)
      add :company_buyer_id, references(:companies)
    end

    create unique_index(:invoices, :company_seller_id)
    create unique_index(:invoices, :company_buyer_id)
  end
end
