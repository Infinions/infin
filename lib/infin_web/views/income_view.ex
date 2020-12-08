defmodule InfinWeb.IncomeView do
  use InfinWeb, :view

  def contains_income?(assigns) do
    assigns[:income]
  end

  def get_value(income) do
    if income.value do
      Decimal.new(income.value) |> Decimal.div(100) |> Decimal.round(2)
    else
      "0.00"
    end
  end
end
