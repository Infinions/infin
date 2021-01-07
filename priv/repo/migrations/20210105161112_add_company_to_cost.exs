defmodule Infin.Repo.Migrations.AddCompanyToCost do
  use Ecto.Migration

  def change do
    alter table("costs") do
      add :company_id, references(:companies)
    end

    create index(:costs, :company_id)
  end
end
