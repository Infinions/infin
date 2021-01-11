defmodule InfinWeb.SaftParserController do
  use InfinWeb, :controller

  alias Infin.SaftParser
  alias Infin.Storage

  def import_saft_pt(conn, params, company_id) do
    case Storage.create_pdf(%{pdf: params["saft_import"]["pdf"]}) do
      {:ok, pdf} ->
        case SaftParser.parse_xml("./uploads/" <> pdf.pdf.file_name, company_id) do
          {:ok, _list} ->
            conn
            |> put_flash(:info, "Income imported successfully.")
            |> redirect(to: Routes.income_path(conn, :index))

          {:error, message} ->
            conn
            |> put_flash(:error, message)
            |> redirect(to: Routes.income_path(conn, :index))
        end

        Storage.delete_pdf(pdf)

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to import income, try again later.")
        |> redirect(to: Routes.income_path(conn, :index))
    end
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company.id]
    apply(__MODULE__, action_name(conn), args)
  end
end
