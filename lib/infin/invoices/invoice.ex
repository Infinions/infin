defmodule Infin.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset
  alias Infin.Invoices.Tag

  schema "invoices" do
    field :id_document, :string

    many_to_many :tags, Tag, join_through: "invoices_tags"
    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:id_document])
    |> validate_required([:id_document])
  end
end
