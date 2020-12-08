defmodule Infin.Revenue.Income do
  use Ecto.Schema
  import Ecto.Changeset

  schema "income" do
    field :date, :string
    field :description, :string
    field :value, :integer

    belongs_to :company, Infin.Companies.Company, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(income, attrs) do
    income
    |> cast(attrs, [:value, :date, :description, :company_id])
    |> validate_required([:value, :date, :description, :company_id])
  end
end
