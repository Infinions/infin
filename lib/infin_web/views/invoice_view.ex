defmodule InfinWeb.InvoiceView do
  use InfinWeb, :view

  def contains_invoice?(assigns) do
    assigns[:invoice]
  end

  def get_total_value(changeset) do
    if changeset.data.total_value do
      Decimal.new(changeset.data.total_value) |> Decimal.div(100) |> Decimal.round(2)
    else
      "0.00"
    end
  end
end
