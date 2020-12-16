defmodule InfinWeb.DashboardLive.Cards do
  use Phoenix.LiveComponent

  @impl true
  def update(assigns, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 3000)

    expenses = -100200
    expenses_change = 2
    income = assigns.company_id * :rand.uniform(10)
    income_change = 15

    {:ok, assign(socket, expenses: expenses, expenses_change: expenses_change, income: income, income_change: income_change)}
  end
end
