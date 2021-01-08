defmodule Infin.Costs.Cost do
  use Ecto.Schema
  import Ecto.Changeset

  schema "costs" do
    field :date, :string
    field :description, :string
    field :value, :integer

    belongs_to :company, Infin.Companies.Company

    timestamps()
  end

  @doc false
  def changeset(cost, attrs) do
    cost
    |> cast(attrs, [:value, :date, :description, :company_id])
    |> validate_required([:value, :date, :description, :company_id])
  end
end
