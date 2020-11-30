defmodule InfinWeb.InvoiceView do
  use InfinWeb, :view

  alias Infin.Invoices.Tag

  def contains_invoice?(assigns) do
    assigns[:invoice]
  end

  def tags_to_string([%Tag{}] = tags) do
    Enum.reduce(tags, "", fn tag, acc ->
      case acc do
        "" ->
          tag.name

        _ ->
          tag.name <> ", " <> acc
      end
    end)
  end
end
