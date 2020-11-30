defmodule Infin.ImporterTest do
  use Infin.DataCase

  alias Infin.Importer

  describe "invoice_importers" do
    alias Infin.Importer.Invoice_Importer

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def invoice__importer_fixture(attrs \\ %{}) do
      {:ok, invoice__importer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Importer.create_invoice__importer()

      invoice__importer
    end

    test "list_invoice_importers/0 returns all invoice_importers" do
      invoice__importer = invoice__importer_fixture()
      assert Importer.list_invoice_importers() == [invoice__importer]
    end

    test "get_invoice__importer!/1 returns the invoice__importer with given id" do
      invoice__importer = invoice__importer_fixture()
      assert Importer.get_invoice__importer!(invoice__importer.id) == invoice__importer
    end

    test "create_invoice__importer/1 with valid data creates a invoice__importer" do
      assert {:ok, %Invoice_Importer{} = invoice__importer} = Importer.create_invoice__importer(@valid_attrs)
    end

    test "create_invoice__importer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Importer.create_invoice__importer(@invalid_attrs)
    end

    test "update_invoice__importer/2 with valid data updates the invoice__importer" do
      invoice__importer = invoice__importer_fixture()
      assert {:ok, %Invoice_Importer{} = invoice__importer} = Importer.update_invoice__importer(invoice__importer, @update_attrs)
    end

    test "update_invoice__importer/2 with invalid data returns error changeset" do
      invoice__importer = invoice__importer_fixture()
      assert {:error, %Ecto.Changeset{}} = Importer.update_invoice__importer(invoice__importer, @invalid_attrs)
      assert invoice__importer == Importer.get_invoice__importer!(invoice__importer.id)
    end

    test "delete_invoice__importer/1 deletes the invoice__importer" do
      invoice__importer = invoice__importer_fixture()
      assert {:ok, %Invoice_Importer{}} = Importer.delete_invoice__importer(invoice__importer)
      assert_raise Ecto.NoResultsError, fn -> Importer.get_invoice__importer!(invoice__importer.id) end
    end

    test "change_invoice__importer/1 returns a invoice__importer changeset" do
      invoice__importer = invoice__importer_fixture()
      assert %Ecto.Changeset{} = Importer.change_invoice__importer(invoice__importer)
    end
  end
end
