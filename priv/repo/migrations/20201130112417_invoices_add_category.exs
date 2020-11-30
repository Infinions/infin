defmodule Infin.Repo.Migrations.InvoicesAddCategory do
  use Ecto.Migration

  def change do
    alter table ("invoices") do
      add :category_id, references (:categories)
    end
  end
end
