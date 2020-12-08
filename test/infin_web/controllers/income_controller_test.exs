defmodule InfinWeb.IncomeControllerTest do
  use InfinWeb.ConnCase


  import Infin.Factory

  setup :register_and_log_in_user

  @create_attrs %{date: "some date", description: "some description", value: 42}
  @invalid_attrs %{date: nil, description: nil, value: nil}

  def fixture() do
    company = insert(:company)
    insert(:income, company_id: company.id)
  end

  describe "index" do
    test "lists all income", %{conn: conn} do
      conn = get(conn, Routes.income_path(conn, :index))
      assert html_response(conn, 200) =~ "Income"
    end
  end

  describe "new income" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.income_path(conn, :new))
      assert html_response(conn, 200) =~ "New Income"
    end
  end

  describe "create income" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.income_path(conn, :create), income: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.income_path(conn, :show, id)

      conn = get(conn, Routes.income_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Income"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.income_path(conn, :create), income: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Income"
    end
  end

  describe "update income" do
    setup [:create_income]

    test "redirects when data is valid", %{conn: conn, income: income} do
      conn = get(conn, Routes.income_path(conn, :show, income))
      assert html_response(conn, 200) =~ "Income"
    end

    test "renders errors when data is invalid", %{conn: conn, income: income} do
      conn = put(conn, Routes.income_path(conn, :update, income), income: @invalid_attrs)
      assert html_response(conn, 200) =~ "Income"
    end
  end

  describe "delete income" do
    setup [:create_income]

    test "deletes chosen income", %{conn: conn, income: income} do
      conn = delete(conn, Routes.income_path(conn, :delete, income))
      assert redirected_to(conn) == Routes.income_path(conn, :index)
    end
  end

  defp create_income(_) do
    income = fixture()
    %{income: income}
  end
end
