defmodule Infin.Repo.Migrations.AddPdfInvoice do
  use Ecto.Migration

  def change do
    alter table("invoices") do
      add :pdf_id, references(:companies)
    end

    create index(:invoices, :pdf_id)
  end
end
