defmodule Infin.Repo.Migrations.AddTagInvoices do
  use Ecto.Migration

  def change do
    alter table("invoices") do
      add :invoice_tag_id, references(:invoices_tags)
    end
  end
end
