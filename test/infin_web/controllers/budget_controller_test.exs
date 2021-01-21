defmodule InfinWeb.BudgetControllerTest do
  use InfinWeb.ConnCase

  import Infin.Factory

  setup :register_and_log_in_user


  def fixture() do
    company = insert(:company)
    category = insert(:category, company_id: company.id)
    insert(:budget, company_id: company.id, category_id: category.id)
  end

  describe "index" do
    test "lists all budgets", %{conn: conn} do
      conn = get(conn, Routes.budget_path(conn, :index))
      assert html_response(conn, 200) =~ "Budgets"
    end
  end

  describe "new budget" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.budget_path(conn, :new))
      assert html_response(conn, 200) =~ "Budget"
    end
  end

  describe "update budget" do
    setup [:create_budget]

    test "redirects when data is valid", %{conn: conn, budget: budget} do
      conn = get(conn, Routes.budget_path(conn, :show, budget))
      assert html_response(conn, 200) =~ "Budget"
    end
  end

  describe "delete budget" do
    setup [:create_budget]

    test "deletes chosen budget", %{conn: conn, budget: budget} do
      conn = delete(conn, Routes.budget_path(conn, :delete, budget))
      assert redirected_to(conn) == Routes.budget_path(conn, :index)
    end
  end

  defp create_budget(_) do
    budget = fixture()
    %{budget: budget}
  end
end
