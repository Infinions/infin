defmodule Infin.Storage.Pdf do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Infin.Storage.File

  schema "pdfs" do
    field :pdf, File.Type
    field :title, :string


    timestamps()
  end

  @doc false
  def changeset(pdf, attrs) do
    pdf
    |> cast(attrs, [:title])
    |> cast_attachments(attrs, [:pdf])
    |> validate_required([:pdf])
  end
end
