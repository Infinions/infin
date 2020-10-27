defmodule Infin.Companies.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    belongs_to :company, Infin.Companies.Company

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :company_id])
    |> validate_required(:name)
    |> unique_constraint([:name, :company_id])
    #|> cast_assoc(:company_id, required: true)
  end

  def category_changeset(company, attrs) do
    company
    |> cast(attrs, [:company_id])
    |> validate_required([:company_id])
  end
end
