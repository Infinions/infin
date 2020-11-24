defmodule InfinWeb.InvoiceView do
  use InfinWeb, :view

  def contains_invoice?(assigns) do
    assigns[:invoice]
  end
end
