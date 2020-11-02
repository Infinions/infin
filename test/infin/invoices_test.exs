defmodule Infin.InvoicesTest do
  use Infin.DataCase

  import Infin.Factory

  alias Infin.Invoices

  describe "invoices" do
    alias Infin.Invoices.Invoice

    @valid_attrs %{id_document: "some id_document"}
    @update_attrs %{id_document: "some updated id_document"}
    @invalid_attrs %{id_document: nil}

    def invoice_fixture() do
      insert(:invoice)
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
end
