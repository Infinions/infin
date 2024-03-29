defmodule Infin.Companies.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    belongs_to :company, Infin.Companies.Company, on_replace: :nilify
    has_many :invoices, Infin.Invoices.Invoice, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :company_id])
    |> validate_required([:name, :company_id])
    |> unique_constraint([:name, :company_id])
  end
end
