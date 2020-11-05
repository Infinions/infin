defmodule Infin.InvoicesTest do
  use Infin.DataCase

  import Infin.Factory

  alias Infin.Invoices

  describe "invoices" do
    alias Infin.Invoices.Invoice

    @valid_attrs %{
      id_document: "some id_document",
      registration_orig: "string",
      registration_orig_desc: "string",
      doc_type: "string",
      doc_type_dec: "string",
      doc_number: "string",
      doc_hash: "string",
      doc_emition_date: "string",
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
      is_foreign: true
    }
    @update_attrs %{id_document: "some updated id_document"}
    @invalid_attrs %{id_document: nil}

    def invoice_fixture() do
      company1 = insert(:company)
      company2 = insert(:company)
      insert(:invoice, company_seller_id: company1.id, company_buyer_id: company2.id)
    end

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Invoices.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Invoices.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      assert {:ok, %Invoice{} = invoice} = Invoices.create_invoice(@valid_attrs)
      assert invoice.id_document == "some id_document"
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoices.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{} = invoice} = Invoices.update_invoice(invoice, @update_attrs)
      assert invoice.id_document == "some updated id_document"
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Invoices.update_invoice(invoice, @invalid_attrs)
      assert invoice == Invoices.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Invoices.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Invoices.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Invoices.change_invoice(invoice)
    end
  end

  describe "tag" do
    alias Infin.Invoices.Tag

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil, company_id: nil}

    def company_fixture() do
      insert(:company)
    end

    def tag_fixture() do
      company = insert(:company)
      insert(:tag, company_id: company.id)
    end

    test "list_tag/0 returns all tag" do
      tag = tag_fixture()
      assert Invoices.list_tag() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Invoices.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      company = company_fixture()
      attrs =%{name: "some name", company_id: company.id}
      assert {:ok, %Tag{} = tag} = Invoices.create_tag(attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoices.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Invoices.update_tag(tag, @update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Invoices.update_tag(tag, @invalid_attrs)
      assert tag == Invoices.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Invoices.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Invoices.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Invoices.change_tag(tag)
    end
  end
end
