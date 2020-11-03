defmodule Infin.Repo.Migrations.AddInvoiceTags do
  use Ecto.Migration

  def change do
    alter table("tags") do
      add :invoice_tag_id, references(:invoices_tags)
    end
  end
end
