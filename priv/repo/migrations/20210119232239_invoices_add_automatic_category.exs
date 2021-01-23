defmodule Infin.Repo.Migrations.InvoicesAddAutomaticCategory do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add :automatic_category, :boolean, default: false
    end
  end
end
