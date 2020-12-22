defmodule Infin.StorageTest do
  use Infin.DataCase

  alias Infin.Storage

  describe "pdfs" do
    alias Infin.Storage.Pdf

    @valid_attrs %{pdf: "some pdf", title: "some title"}
    @update_attrs %{pdf: "some updated pdf", title: "some updated title"}
    @invalid_attrs %{pdf: nil, title: nil}

    def pdf_fixture(attrs \\ %{}) do
      {:ok, pdf} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Storage.create_pdf()

      pdf
    end

    test "list_pdfs/0 returns all pdfs" do
      pdf = pdf_fixture()
      assert Storage.list_pdfs() == [pdf]
    end

    test "get_pdf!/1 returns the pdf with given id" do
      pdf = pdf_fixture()
      assert Storage.get_pdf!(pdf.id) == pdf
    end

    test "create_pdf/1 with valid data creates a pdf" do
      assert {:ok, %Pdf{} = pdf} = Storage.create_pdf(@valid_attrs)
      assert pdf.pdf == "some pdf"
      assert pdf.title == "some title"
    end

    test "create_pdf/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Storage.create_pdf(@invalid_attrs)
    end

    test "update_pdf/2 with valid data updates the pdf" do
      pdf = pdf_fixture()
      assert {:ok, %Pdf{} = pdf} = Storage.update_pdf(pdf, @update_attrs)
      assert pdf.pdf == "some updated pdf"
      assert pdf.title == "some updated title"
    end

    test "update_pdf/2 with invalid data returns error changeset" do
      pdf = pdf_fixture()
      assert {:error, %Ecto.Changeset{}} = Storage.update_pdf(pdf, @invalid_attrs)
      assert pdf == Storage.get_pdf!(pdf.id)
    end

    test "delete_pdf/1 deletes the pdf" do
      pdf = pdf_fixture()
      assert {:ok, %Pdf{}} = Storage.delete_pdf(pdf)
      assert_raise Ecto.NoResultsError, fn -> Storage.get_pdf!(pdf.id) end
    end

    test "change_pdf/1 returns a pdf changeset" do
      pdf = pdf_fixture()
      assert %Ecto.Changeset{} = Storage.change_pdf(pdf)
    end
  end
end
