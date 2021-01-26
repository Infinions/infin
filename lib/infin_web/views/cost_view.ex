defmodule InfinWeb.CostView do
  use InfinWeb, :view

  def contains_cost?(assigns) do
    assigns[:cost]
  end

  def get_value(cost) do
    if cost.value do
      Decimal.new(cost.value) |> Decimal.div(100) |> Decimal.round(2)
    else
      "0.00"
    end
  end
end
