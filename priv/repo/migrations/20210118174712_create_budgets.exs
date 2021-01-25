defmodule Infin.Repo.Migrations.CreateBudgets do
  use Ecto.Migration

  def change do
    create table(:budgets) do
      add :value, :integer
      add :init_date, :string
      add :end_date, :string

      timestamps()
    end

  end
end
