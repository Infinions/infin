defmodule Infin.Repo.Migrations.CreateEnterprises do
  use Ecto.Migration

  def change do
    create table(:enterprises) do
      add :name, :string, null: false
      add :nif, :string, null: false

      timestamps()
    end

    create unique_index(:enterprises, [:nif])
  end
end
