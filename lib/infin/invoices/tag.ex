defmodule Infin.Invoices.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Infin.Invoices.Invoice

  schema "tags" do
    field :name, :string

    many_to_many :invoices, Invoice, join_through: "invoices_tags"
    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
