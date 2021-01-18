defmodule Infin.Repo.Migrations.AddCategoryToBudgets do
  use Ecto.Migration

  def change do
    alter table("budgets") do
      add :company_id, references(:companies)
    end

    create index(:budgets, :company_id)
  end
end
