defmodule InfinWeb.BudgetController do
  use InfinWeb, :controller

  alias Infin.Budgets
  alias Infin.Budgets.Budget
  alias Infin.Companies

  def index(conn, params, company_id) do
    page = Budgets.list_budgets(params, company_id)
    render(conn, "index.html", budgets: page.entries, page: page)
  end

  def new(conn, _params, company_id) do
    changeset = Budgets.change_budget(%Budget{})

    categories =
      Companies.list_company_categories(company_id)
      |> Enum.map(&{&1.name, &1.id})

    render(conn, "new.html", changeset: changeset, categories: categories)
  end

  def create(conn, %{"budget" => budget_params}, company_id) do
    value =
      Decimal.new(budget_params["value"])
      |> Decimal.mult(100)
      |> Decimal.round(0, :ceiling)
      |> Decimal.to_integer()

    budget_params = Map.replace!(budget_params, "value", value)

    budget_params =
      Map.replace!(
        budget_params,
        "category_id",
        String.to_integer(budget_params["category_id"])
      )

    case Budgets.create_budget(budget_params, company_id) do
      {:ok, budget} ->
        conn
        |> put_flash(:info, "Budget created successfully.")
        |> redirect(to: Routes.budget_path(conn, :show, budget))

      {:error, %Ecto.Changeset{} = changeset} ->
        categories =
          Companies.list_company_categories(company_id)
          |> Enum.map(&{&1.name, &1.id})

        render(conn, "new.html", changeset: changeset, categories: categories)
    end
  end

  def show(conn, %{"id" => id}, company_id) do
    case Budgets.get_budget!(id) do
      nil ->
        index(conn, %{"page" => 1}, company_id)

      budget ->
        cond do
          company_id == budget.company_id ->
            categories =
              Companies.list_company_categories(company_id)
              |> Enum.map(&{&1.name, &1.id})

            changeset = Budgets.change_budget(budget)

            render(conn, "show.html",
              budget: budget,
              changeset: changeset,
              categories: categories
            )

          true ->
            index(conn, %{"page" => 1}, company_id)
        end
    end
  end

  def update(conn, %{"id" => id, "budget" => budget_params}, company_id) do
    budget_params =
      Map.replace!(
        budget_params,
        "category_id",
        String.to_integer(budget_params["category_id"])
      )

    case Budgets.get_budget(id) do
      nil ->
        index(conn, %{"page" => 1}, company_id)

      budget ->
        cond do
          company_id == budget.company_id ->
            value =
              Decimal.new(budget_params["value"])
              |> Decimal.mult(100)
              |> Decimal.round(0, :ceiling)
              |> Decimal.to_integer()

            budget_params = Map.replace!(budget_params, "value", value)

            case Budgets.update_budget(budget, budget_params) do
              {:ok, budget} ->
                conn
                |> put_flash(:info, "Budget updated successfully.")
                |> redirect(to: Routes.budget_path(conn, :show, budget))

              {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "show.html",
                  budget: budget,
                  changeset: changeset
                )
            end

          true ->
            index(conn, %{"page" => 1}, company_id)
        end
    end
  end

  def delete(conn, %{"id" => id}, company_id) do
    case Budgets.get_budget(id) do
      nil ->
        index(conn, %{}, company_id)

      budget ->
        cond do
          company_id == budget.company_id ->
            {:ok, _budget} = Budgets.delete_budget(budget)

          true ->
            index(conn, %{}, company_id)
        end
    end

    conn
    |> put_flash(:info, "Budget deleted successfully.")
    |> redirect(to: Routes.budget_path(conn, :index))
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company.id]
    apply(__MODULE__, action_name(conn), args)
  end
end
