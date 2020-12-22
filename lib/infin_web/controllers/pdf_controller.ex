defmodule InfinWeb.PdfController do
  use InfinWeb, :controller

  alias Infin.Storage
  alias Infin.Storage.Pdf

  def index(conn, _params) do
    pdfs = Storage.list_pdfs()
    render(conn, "index.html", pdfs: pdfs)
  end

  def new(conn, _params) do
    changeset = Storage.change_pdf(%Pdf{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"pdf" => pdf_params}) do
    case Storage.create_pdf(pdf_params) do
      {:ok, pdf} ->
        conn
        |> put_flash(:info, "Pdf created successfully.")
        |> redirect(to: Routes.pdf_path(conn, :show, pdf))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pdf = Storage.get_pdf!(id)
    render(conn, "show.html", pdf: pdf)
  end

  def edit(conn, %{"id" => id}) do
    pdf = Storage.get_pdf!(id)
    changeset = Storage.change_pdf(pdf)
    render(conn, "edit.html", pdf: pdf, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pdf" => pdf_params}) do
    pdf = Storage.get_pdf!(id)

    case Storage.update_pdf(pdf, pdf_params) do
      {:ok, pdf} ->
        conn
        |> put_flash(:info, "Pdf updated successfully.")
        |> redirect(to: Routes.pdf_path(conn, :show, pdf))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", pdf: pdf, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pdf = Storage.get_pdf!(id)
    {:ok, _pdf} = Storage.delete_pdf(pdf)

    conn
    |> put_flash(:info, "Pdf deleted successfully.")
    |> redirect(to: Routes.pdf_path(conn, :index))
  end
end
