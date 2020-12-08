defmodule Infin.Repo.Migrations.IncomeAddCompany do
  use Ecto.Migration

  def change do
    alter table("income") do
      add :company_id, references(:companies)
    end

    create unique_index(:income, :company_id)
  end
end
