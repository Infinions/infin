defmodule InfinWeb.CompanyControllerTest do
  use InfinWeb.ConnCase, async: true

  import Infin.Factory

  alias Infin.Accounts

  setup :register_and_log_in_user

  @update_attrs %{name: "some updated name"}
  @invalid_update_attrs %{name: nil}
  @invalid_update_nif_attrs %{nif: "AZ91"}

  def fixture(:company) do
    insert(:company)
  end

  describe "edit company" do
    setup [:create_company]

    test "renders form for editing chosen company", %{conn: conn, company: company, user: user} do
      Accounts.change_user_company(user, company)

      conn = get(conn, Routes.company_path(conn, :show, company))
      assert html_response(conn, 200) =~ "Settings"
    end
  end

  describe "update company" do
    setup [:create_company]

    test "redirects when data is valid", %{conn: conn, company: company, user: user} do
      Accounts.change_user_company(user, company)

      conn = put(conn, Routes.company_path(conn, :update, company), company: @update_attrs)
      assert redirected_to(conn) == Routes.company_path(conn, :show, company)

      conn = get(conn, Routes.company_path(conn, :show, company))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "redirects when editing trying to edit the nif", %{
      conn: conn,
      company: company,
      user: user
    } do
      Accounts.change_user_company(user, company)

      conn =
        put(conn, Routes.company_path(conn, :update, company), company: @invalid_update_nif_attrs)

      assert html_response(conn, 302)
      refute company.nif == "AZ91"
    end

    test "renders errors when data is invalid", %{conn: conn, company: company, user: user} do
      Accounts.change_user_company(user, company)

      conn =
        put(conn, Routes.company_path(conn, :update, company), company: @invalid_update_attrs)

      assert html_response(conn, 200) =~ "Settings"
    end
  end

  defp create_company(_) do
    company = fixture(:company)
    %{company: company}
  end
end
