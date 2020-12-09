defmodule InfinWeb.DashboardLive.Cards do
  use Phoenix.LiveComponent

  @impl true
  def update(assigns, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 3000)

    expenses = -100200
    income = assigns.company_id * :rand.uniform(10)

    {:ok, assign(socket, expenses: expenses, income: income)}
  end
end
