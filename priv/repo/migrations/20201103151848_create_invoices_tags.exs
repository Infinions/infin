defmodule Infin.Repo.Migrations.CreateInvoicesTags do
  use Ecto.Migration

  def change do
    create table(:invoices_tags) do
      add :invoice_id, references(:invoices)
      add :tag_id, references(:tags)

      timestamps()
    end
  end
end
