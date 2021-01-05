defmodule InfinWeb.CostControllerTest do
  use InfinWeb.ConnCase


  import Infin.Factory

  setup :register_and_log_in_user

  @create_attrs %{date: "some date", description: "some description", value: 42}
  @invalid_attrs %{date: nil, description: nil, value: "0.00"}

  def fixture() do
    company = insert(:company)
    insert(:cost, company_id: company.id)
  end

  describe "index" do
    test "lists all costs", %{conn: conn} do
      conn = get(conn, Routes.cost_path(conn, :index))
      assert html_response(conn, 200) =~ "Costs"
    end
  end

  describe "new cost" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.cost_path(conn, :new))
      assert html_response(conn, 200) =~ "New Expense"
    end
  end

  describe "create cost" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cost_path(conn, :create), cost: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.cost_path(conn, :show, id)

      conn = get(conn, Routes.cost_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Cost"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cost_path(conn, :create), cost: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Expense"
    end
  end

  describe "update cost" do
    setup [:create_cost]

    test "redirects when data is valid", %{conn: conn, cost: cost} do
      conn = get(conn, Routes.cost_path(conn, :show, cost))
      assert html_response(conn, 200) =~ "Cost"
    end

    test "renders errors when data is invalid", %{conn: conn, cost: cost} do
      conn = put(conn, Routes.cost_path(conn, :update, cost), cost: @invalid_attrs)
      assert html_response(conn, 200) =~ "Cost"
    end
  end

  describe "delete cost" do
    setup [:create_cost]

    test "deletes chosen cost", %{conn: conn, cost: cost} do
      conn = delete(conn, Routes.cost_path(conn, :delete, cost))
      assert redirected_to(conn) == Routes.cost_path(conn, :index)
    end
  end

  defp create_cost(_) do
    cost = fixture()
    %{cost: cost}
  end
end
