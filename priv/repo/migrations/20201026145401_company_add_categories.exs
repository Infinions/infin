defmodule Infin.Repo.Migrations.CompanyAddCategories do
  use Ecto.Migration

  def change do
    alter table("categories") do
      add :company_id, references(:companies)
    end

    create unique_index(:categories, [:name, :company_id])
  end
end
