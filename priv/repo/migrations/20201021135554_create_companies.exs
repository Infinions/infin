defmodule Infin.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :nif, :string

      timestamps()
    end

    create unique_index(:companies, [:name])
    create unique_index(:companies, [:nif])
  end
end
