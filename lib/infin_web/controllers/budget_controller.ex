defmodule InfinWeb.BudgetController do
  use InfinWeb, :controller

  alias Infin.Budgets
  alias Infin.Budgets.Budget

  def index(conn, _params) do
    budgets = Budgets.list_budgets()
    render(conn, "index.html", budgets: budgets)
  end

  def new(conn, _params) do
    changeset = Budgets.change_budget(%Budget{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"budget" => budget_params}) do
    case Budgets.create_budget(budget_params) do
      {:ok, budget} ->
        conn
        |> put_flash(:info, "Budget created successfully.")
        |> redirect(to: Routes.budget_path(conn, :show, budget))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    budget = Budgets.get_budget!(id)
    render(conn, "show.html", budget: budget)
  end

  def edit(conn, %{"id" => id}) do
    budget = Budgets.get_budget!(id)
    changeset = Budgets.change_budget(budget)
    render(conn, "edit.html", budget: budget, changeset: changeset)
  end

  def update(conn, %{"id" => id, "budget" => budget_params}) do
    budget = Budgets.get_budget!(id)

    case Budgets.update_budget(budget, budget_params) do
      {:ok, budget} ->
        conn
        |> put_flash(:info, "Budget updated successfully.")
        |> redirect(to: Routes.budget_path(conn, :show, budget))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", budget: budget, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    budget = Budgets.get_budget!(id)
    {:ok, _budget} = Budgets.delete_budget(budget)

    conn
    |> put_flash(:info, "Budget deleted successfully.")
    |> redirect(to: Routes.budget_path(conn, :index))
  end
end
