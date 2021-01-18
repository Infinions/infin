defmodule InfinWeb.BudgetControllerTest do
  use InfinWeb.ConnCase

  alias Infin.Budgets

  @create_attrs %{end_date: "some end_date", init_date: "some init_date", value: 42}
  @update_attrs %{end_date: "some updated end_date", init_date: "some updated init_date", value: 43}
  @invalid_attrs %{end_date: nil, init_date: nil, value: nil}

  def fixture(:budget) do
    {:ok, budget} = Budgets.create_budget(@create_attrs)
    budget
  end

  describe "index" do
    test "lists all budgets", %{conn: conn} do
      conn = get(conn, Routes.budget_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Budgets"
    end
  end

  describe "new budget" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.budget_path(conn, :new))
      assert html_response(conn, 200) =~ "New Budget"
    end
  end

  describe "create budget" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.budget_path(conn, :create), budget: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.budget_path(conn, :show, id)

      conn = get(conn, Routes.budget_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Budget"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.budget_path(conn, :create), budget: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Budget"
    end
  end

  describe "edit budget" do
    setup [:create_budget]

    test "renders form for editing chosen budget", %{conn: conn, budget: budget} do
      conn = get(conn, Routes.budget_path(conn, :edit, budget))
      assert html_response(conn, 200) =~ "Edit Budget"
    end
  end

  describe "update budget" do
    setup [:create_budget]

    test "redirects when data is valid", %{conn: conn, budget: budget} do
      conn = put(conn, Routes.budget_path(conn, :update, budget), budget: @update_attrs)
      assert redirected_to(conn) == Routes.budget_path(conn, :show, budget)

      conn = get(conn, Routes.budget_path(conn, :show, budget))
      assert html_response(conn, 200) =~ "some updated end_date"
    end

    test "renders errors when data is invalid", %{conn: conn, budget: budget} do
      conn = put(conn, Routes.budget_path(conn, :update, budget), budget: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Budget"
    end
  end

  describe "delete budget" do
    setup [:create_budget]

    test "deletes chosen budget", %{conn: conn, budget: budget} do
      conn = delete(conn, Routes.budget_path(conn, :delete, budget))
      assert redirected_to(conn) == Routes.budget_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.budget_path(conn, :show, budget))
      end
    end
  end

  defp create_budget(_) do
    budget = fixture(:budget)
    %{budget: budget}
  end
end
