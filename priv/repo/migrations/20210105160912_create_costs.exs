defmodule Infin.Repo.Migrations.CreateCosts do
  use Ecto.Migration

  def change do
    create table(:costs) do
      add :value, :integer
      add :date, :string
      add :description, :string

      timestamps()
    end

  end
end
