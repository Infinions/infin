defmodule InfinWeb.BudgetControllerTest do
  use InfinWeb.ConnCase

  import Infin.Factory

  setup :register_and_log_in_user

  @create_attrs %{end_date: "some end_date", init_date: "some init_date", value: 42}
  @invalid_attrs %{end_date: "some end_date", init_date: nil, value: "0.00"}

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

  describe "create budget" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.budget_path(conn, :create), budget: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.budget_path(conn, :show, id)

      conn = get(conn, Routes.budget_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Budget"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.budget_path(conn, :create), budget: @invalid_attrs)
      assert html_response(conn, 200) =~ "Budget"
    end
  end

  describe "update budget" do
    setup [:create_budget]

    test "redirects when data is valid", %{conn: conn, budget: budget} do
      conn = get(conn, Routes.budget_path(conn, :show, budget))
      assert html_response(conn, 200) =~ "Budget"
    end

    test "renders errors when data is invalid", %{conn: conn, budget: budget} do
      conn = put(conn, Routes.budget_path(conn, :update, budget), budget: @invalid_attrs)
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
