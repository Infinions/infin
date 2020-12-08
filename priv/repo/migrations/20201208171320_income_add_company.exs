defmodule Infin.Repo.Migrations.IncomeAddCompany do
  use Ecto.Migration

  def change do
    alter table("incomes") do
      add :company_id, references(:companies)
    end

    create index(:incomes, :company_id)
  end
end
