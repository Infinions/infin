defmodule Infin.Repo.Migrations.CompanyAddTags do
  use Ecto.Migration

  def change do
    alter table("tags") do
      add :company_id, references(:companies)
    end

    create unique_index(:tags, [:name, :company_id])
  end
end
