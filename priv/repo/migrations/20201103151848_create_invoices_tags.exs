defmodule Infin.Repo.Migrations.CreateInvoicesTags do
  use Ecto.Migration

  def change do
    create table(:invoices_tags) do
      add :invoice_id, :string
      add :tag_id, :string

      timestamps()
    end
  end
end
