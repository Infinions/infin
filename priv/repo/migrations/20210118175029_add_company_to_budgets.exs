defmodule Infin.Repo.Migrations.AddCompanyToBudgets do
  use Ecto.Migration

  def change do
    alter table("budgets") do
      add :category_id, references(:categories)
    end

    create index(:budgets, :category_id)
  end
end
