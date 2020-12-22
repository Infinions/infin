defmodule InfinWeb.PdfControllerTest do
  use InfinWeb.ConnCase

  alias Infin.Storage

  @create_attrs %{pdf: "some pdf", title: "some title"}
  @update_attrs %{pdf: "some updated pdf", title: "some updated title"}
  @invalid_attrs %{pdf: nil, title: nil}

  def fixture(:pdf) do
    {:ok, pdf} = Storage.create_pdf(@create_attrs)
    pdf
  end

  describe "index" do
    test "lists all pdfs", %{conn: conn} do
      conn = get(conn, Routes.pdf_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pdfs"
    end
  end

  describe "new pdf" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.pdf_path(conn, :new))
      assert html_response(conn, 200) =~ "New Pdf"
    end
  end

  describe "create pdf" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pdf_path(conn, :create), pdf: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.pdf_path(conn, :show, id)

      conn = get(conn, Routes.pdf_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Pdf"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pdf_path(conn, :create), pdf: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Pdf"
    end
  end

  describe "edit pdf" do
    setup [:create_pdf]

    test "renders form for editing chosen pdf", %{conn: conn, pdf: pdf} do
      conn = get(conn, Routes.pdf_path(conn, :edit, pdf))
      assert html_response(conn, 200) =~ "Edit Pdf"
    end
  end

  describe "update pdf" do
    setup [:create_pdf]

    test "redirects when data is valid", %{conn: conn, pdf: pdf} do
      conn = put(conn, Routes.pdf_path(conn, :update, pdf), pdf: @update_attrs)
      assert redirected_to(conn) == Routes.pdf_path(conn, :show, pdf)

      conn = get(conn, Routes.pdf_path(conn, :show, pdf))
      assert html_response(conn, 200) =~ "some updated pdf"
    end

    test "renders errors when data is invalid", %{conn: conn, pdf: pdf} do
      conn = put(conn, Routes.pdf_path(conn, :update, pdf), pdf: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Pdf"
    end
  end

  describe "delete pdf" do
    setup [:create_pdf]

    test "deletes chosen pdf", %{conn: conn, pdf: pdf} do
      conn = delete(conn, Routes.pdf_path(conn, :delete, pdf))
      assert redirected_to(conn) == Routes.pdf_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.pdf_path(conn, :show, pdf))
      end
    end
  end

  defp create_pdf(_) do
    pdf = fixture(:pdf)
    %{pdf: pdf}
  end
end
