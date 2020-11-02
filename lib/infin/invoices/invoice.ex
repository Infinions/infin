defmodule Infin.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :id_document, :string

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:id_document])
    |> validate_required([:id_document])
  end
end
