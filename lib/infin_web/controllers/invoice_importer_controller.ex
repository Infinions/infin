defmodule InfinWeb.InvoiceImporterController do
  use InfinWeb, :controller

  alias Infin.Importer

  def import_invoices_pt(conn, params, company_id) do
    case Importer.import_invoices_pt(
           company_id,
           params["password"],
           params["start_date"],
           params["end_date"]
         ) do
      {:ok, message} ->
        conn
        |> put_flash(:info, message)
        |> redirect(to: Routes.invoice_path(conn, :index))

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.invoice_path(conn, :index))
    end
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company.id]
    apply(__MODULE__, action_name(conn), args)
  end
end
