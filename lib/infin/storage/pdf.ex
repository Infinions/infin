defmodule Infin.Storage.Pdf do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Infin.Storage.File

  schema "pdfs" do
    field :pdf, File.Type
    field :title, :string

    has_one :invoice, Infin.Invoices.Invoice
    timestamps()
  end

  @doc false
  def changeset(pdf, attrs) do
    add_timestamp(attrs)
    IO.inspect(attrs)
    pdf
    |> cast(attrs, [:title])
    |> cast_attachments(attrs, [:pdf])
    |> validate_required([:pdf])
  end

  defp add_timestamp(%{"pdf" => %Plug.Upload{filename: name} = pdf} = attrs) do
    pdf = %Plug.Upload{pdf | filename: prepend_timestamp(name)}
    %{attrs | "pdf" => pdf}
  end

  defp add_timestamp(params), do: params

  defp prepend_timestamp(name) do
    "#{:os.system_time()}" <> name
  end
end
