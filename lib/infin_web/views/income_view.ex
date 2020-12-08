defmodule InfinWeb.IncomeView do
  use InfinWeb, :view

  def contains_income?(assigns) do
    assigns[:income]
  end
end
