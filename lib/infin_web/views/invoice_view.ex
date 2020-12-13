defmodule InfinWeb.InvoiceView do
  use InfinWeb, :view

  def contains_invoice?(assigns) do
    assigns[:invoice]
  end

  def get_total_value(invoice) do
    if invoice.total_value do
      Decimal.new(invoice.total_value) |> Decimal.div(100) |> Decimal.round(2)
    else
      "0.00"
    end
  end
end
