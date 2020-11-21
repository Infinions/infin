defmodule InfinWeb.InvoiceView do
  use InfinWeb, :view

  def contains_invoice?(assigns) do
    assigns[:invoice]
  end

  def current_date() do
    d = DateTime.utc_now
    "#{d.month}/#{d.day}/#{d.year}"
  end
end
