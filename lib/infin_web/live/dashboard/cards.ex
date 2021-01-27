defmodule InfinWeb.DashboardLive.Cards do
  use Phoenix.LiveComponent

  alias Infin.Revenue
  alias Infin.Invoices
  alias Infin.Costs

  @impl true
  def update(assigns, socket) do
    {c_income, p_income} = Revenue.get_monthly_income(assigns.company_id)
    {c_invoices, p_invoices} = Invoices.get_monthly_invoices(assigns.company_id)
    {c_costs, p_costs} = Costs.get_monthly_costs(assigns.company_id)

    expenses = get_value(c_invoices + c_costs)
    expenses_change = get_change(c_invoices + c_costs, p_invoices + p_costs)

    income = get_value(c_income)
    income_change = get_change(c_income, p_income)

    {:ok,
     assign(socket,
       expenses: expenses,
       expenses_change: expenses_change,
       income: income,
       income_change: income_change
     )}
  end

  defp get_value(value) do
    Decimal.new(value |> Decimal.div(100) |> Decimal.round(2))
  end

  defp get_change(c, p) do
    case {c, p} do
      {0, 0} ->
        0

      {_, 0} ->
        100

      {0, _} ->
        -100

      _ ->
        v = (c - p) / c
        (v * 100) |> Float.round(2)
    end
  end
end
