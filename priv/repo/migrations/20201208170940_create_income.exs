defmodule Infin.Repo.Migrations.CreateIncome do
  use Ecto.Migration

  def change do
    create table(:income) do
      add :value, :integer
      add :date, :string
      add :description, :string

      timestamps()
    end

  end
end
