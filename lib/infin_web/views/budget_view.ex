defmodule InfinWeb.BudgetView do
  use InfinWeb, :view

  def contains_budget?(assigns) do
    assigns[:budget]
  end

  def get_value(budget) do
    if budget.value do
      Decimal.new(budget.value) |> Decimal.div(100) |> Decimal.round(2)
    else
      "0.00"
    end
  end
end
