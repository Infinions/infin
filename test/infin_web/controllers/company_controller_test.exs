defmodule InfinWeb.CompanyControllerTest do
  use InfinWeb.ConnCase, async: true

  alias Infin.Companies
  alias Infin.Accounts

  setup :register_and_log_in_user

  @create_attrs %{name: "some name", nif: "1234"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{nif: nil}

  def fixture(:company) do
    {:ok, company} = Companies.create_company(@create_attrs)
    company
  end

  describe "edit company" do
    setup [:create_company]

    test "renders form for editing chosen company", %{conn: conn, company: company, user: user} do
      Accounts.change_user_company(user, %{company_id: company.id})

      conn = get(conn, Routes.company_path(conn, :edit, company))
      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  describe "update company" do
    setup [:create_company]

    test "redirects when data is valid", %{conn: conn, company: company, user: user} do
      Accounts.change_user_company(user, %{company_id: company.id})

      conn = put(conn, Routes.company_path(conn, :update, company), company: @update_attrs)
      assert redirected_to(conn) == Routes.company_path(conn, :show, company)

      conn = get(conn, Routes.company_path(conn, :show, company))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, company: company, user: user} do
      Accounts.change_user_company(user, %{company_id: company.id})

      conn = put(conn, Routes.company_path(conn, :update, company), company: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  defp create_company(_) do
    company = fixture(:company)
    %{company: company}
  end
end
