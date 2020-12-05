defmodule InfinWeb.InvoiceControllerTest do
  use InfinWeb.ConnCase

  import Infin.Factory

  setup :register_and_log_in_user

  @create_attrs %{
    id_document: "some id_document",
    registration_orig: "string",
    registration_orig_desc: "string",
    doc_type: "string",
    doc_type_dec: "string",
    doc_number: "string",
    doc_hash: "string",
    doc_emission_date: "string",
    total_value: 100,
    total_base_value: 80,
    total_tax_value: 12,
    total_benef_prov_value: 90,
    total_benef_sector_value: 90,
    total_gen_exp_value: 90,
    benef_state: "string",
    benef_state_desc: "string",
    benef_state_emit: "string",
    benef_state_emit_desc: "string",
    normal_tax_exists: true,
    emit_activity: "string",
    emit_activity_desc: "string",
    prof_activity: "string",
    prof_activity_desc: "string",
    merchant_comm: false,
    consumer_comm: true,
    is_foreign: true,
    company_seller: %{
      nif: "123",
      name: "hello"
    }
  }
  @update_attrs %{id_document: "some updated id_document"}
  @invalid_attrs %{id_document: nil, company_seller: %{
    nif: "123",
    name: "hello"
  }}

  def fixture() do
    company1 = insert(:company)
    company2 = insert(:company)
    insert(:invoice, company_seller_id: company1.id, company_id: company2.id)
  end

  describe "index" do
    test "lists all invoices", %{conn: conn} do
      conn = get(conn, Routes.invoice_path(conn, :index))
      assert html_response(conn, 200) =~ "Invoices"
    end
  end

  describe "new invoice" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.invoice_path(conn, :new))
      assert html_response(conn, 200) =~ "New Invoice"
    end
  end

  describe "create invoice" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.invoice_path(conn, :create), invoice: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.invoice_path(conn, :show, id)

      conn = get(conn, Routes.invoice_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Invoice"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.invoice_path(conn, :create), invoice: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Invoice"
    end
  end

  describe "update invoice" do
    setup [:create_invoice]

    test "redirects when data is valid", %{conn: conn, invoice: invoice} do
      conn = put(conn, Routes.invoice_path(conn, :update, invoice), invoice: @update_attrs)
      assert html_response(conn, 200) =~ "Invoices"

      conn = get(conn, Routes.invoice_path(conn, :show, invoice))
      assert html_response(conn, 200) =~ "New Invoice"
    end

    test "renders errors when data is invalid", %{conn: conn, invoice: invoice} do
      conn = put(conn, Routes.invoice_path(conn, :update, invoice), invoice: @invalid_attrs)
      assert html_response(conn, 200) =~ "Invoices"
    end
  end

  describe "delete invoice" do
    setup [:create_invoice]

    test "deletes chosen invoice", %{conn: conn, invoice: invoice} do
      conn = delete(conn, Routes.invoice_path(conn, :delete, invoice))
      assert redirected_to(conn) == Routes.invoice_path(conn, :index)
    end
  end

  defp create_invoice(_) do
    invoice = fixture()
    %{invoice: invoice}
  end
end
