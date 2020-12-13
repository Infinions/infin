defmodule Infin.Invoices.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string

    belongs_to :company, Infin.Companies.Company, on_replace: :nilify
    many_to_many :invoices, Infin.Invoices.Invoice, join_through: "invoices_tags"

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :company_id])
    |> validate_required([:name, :company_id])
    |> unique_constraint([:name, :company_id])
  end
end
