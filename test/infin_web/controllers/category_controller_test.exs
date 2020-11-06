defmodule InfinWeb.CategoryControllerTest do
  use InfinWeb.ConnCase

  import Infin.Factory

  alias Infin.Companies

  setup :register_and_log_in_user

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:category) do
    company = insert(:company)
    insert(:category, company_id: company.id)
  end

  describe "new category" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.category_path(conn, :new))
      assert html_response(conn, 200) =~ "New Category"
    end
  end

  describe "create category" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.category_path(conn, :create, company_id: user.company.id), category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.category_path(conn, :show, id, company_id: user.company.id)

      conn = get(conn, Routes.category_path(conn, :show, id, company_id: user.company.id))
      assert html_response(conn, 200) =~ "Category"
      assert html_response(conn, 200) =~ "Delete"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = post(conn, Routes.category_path(conn, :create, company_id: user.company.id), category: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Category"
    end
  end

  describe "update category" do
    setup [:create_category]

    test "redirects when data is valid", %{conn: conn, category: category, user: user} do
      Companies.change_category_company(category, user.company)

      conn = put(conn, Routes.category_path(conn, :update, category, company_id: user.company.id), category: @update_attrs)
      assert redirected_to(conn) == Routes.category_path(conn, :show, category, company_id: user.company.id)

      conn = get(conn, Routes.category_path(conn, :show, category, company_id: user.company.id))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, category: category, user: user} do
      Companies.change_category_company(category, user.company)

      conn = put(conn, Routes.category_path(conn, :update, category, company_id: user.company.id), category: @invalid_attrs)
      assert html_response(conn, 200) =~ "Category"
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "deletes chosen category", %{conn: conn, category: category, user: user} do
      Companies.change_category_company(category, user.company)

      conn = delete(conn, Routes.category_path(conn, :delete, category))
      assert redirected_to(conn) == Routes.company_path(conn, :show, user.company.id)
    end
  end

  defp create_category(_) do
    category = fixture(:category)
    %{category: category}
  end
end
