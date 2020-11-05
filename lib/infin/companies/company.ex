defmodule Infin.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string, null: false
    field :nif, :string, null: false

    has_many :users, Infin.Accounts.User
    has_many :categories, Infin.Companies.Category
    has_many :buyer_invoice, Infin.Invoices.Invoice, foreign_key: :company_buyer_id
    has_many :seller_invoice, Infin.Invoices.Invoice, foreign_key: :company_seller_id

    timestamps()
  end

  @doc false
  def registration_changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :nif])
    |> validate_required([:name, :nif])
    |> unique_constraint(:nif)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name])
    |> validate_required(:name)
  end
end
