defmodule Infin.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :id_document, :string

      timestamps()
    end

  end
end
