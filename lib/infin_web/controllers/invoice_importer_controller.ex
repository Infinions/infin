defmodule InfinWeb.InvoiceImporterController do
  use InfinWeb, :controller

  alias Infin.Importer

  def import_invoices_pt(conn, params, company_id) do
    case Importer.import_invoices_pt(
           params["invoice_importer"]["nif"],
           params["invoice_importer"]["password"],
           params["invoice_importer"]["start_date"],
           params["invoice_importer"]["end_date"],
           company_id
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
