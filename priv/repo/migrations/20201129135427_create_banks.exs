defmodule Infin.Repo.Migrations.CreateBanks do
  use Ecto.Migration

  def change do
    create table(:banks) do
      add :bank_id, :string
      add :bic, :string
      add :bank_code, :string
      add :aspsp_cde, :string
      add :name, :string
      add :logo_location, :string

      timestamps()
    end

    create unique_index(:banks, [:bank_id])
  end
end
