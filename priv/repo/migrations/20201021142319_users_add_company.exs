defmodule Infin.Repo.Migrations.UsersAddCompany do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :company_id, references(:companies)
    end
  end
end
