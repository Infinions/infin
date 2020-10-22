defmodule Infin.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string, null: false
    field :nif, :string, null: false
    has_many :users, Infin.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :nif])
    |> validate_required([:name, :nif])
    |> unique_constraint(:name)
    |> unique_constraint(:nif)
  end
end
