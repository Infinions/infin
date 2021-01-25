defmodule Infin.Budgets.Budget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "budgets" do
    field :end_date, :string
    field :init_date, :string
    field :value, :integer

    belongs_to :company, Infin.Companies.Company
    belongs_to :category, Infin.Companies.Category
    timestamps()
  end

  @doc false
  def changeset(budget, attrs) do
    budget
    |> cast(attrs, [:value, :init_date, :end_date, :company_id, :category_id])
    |> validate_required([:value, :init_date, :end_date, :company_id, :category_id])
  end
end
