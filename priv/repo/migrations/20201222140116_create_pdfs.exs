defmodule Infin.Repo.Migrations.CreatePdfs do
  use Ecto.Migration

  def change do
    create table(:pdfs) do
      add :title, :string
      add :pdf, :string

      timestamps()
    end

  end
end
