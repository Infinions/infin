defmodule InfinWeb.InvoiceController do
  use InfinWeb, :controller

  alias Infin.Invoices
  alias Infin.Invoices.Invoice

  def index(conn, _params, company_id) do
    invoices = Invoices.list_company_invoices(company_id)
    render(conn, "index.html", invoices: invoices)
  end

  def new(conn, _params, _company_id) do
    changeset = Invoices.change_invoice(%Invoice{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invoice" => invoice_params}, company_id) do
    case Invoices.create_invoice(invoice_params, company_id) do
      {:ok, invoice} ->
        conn
        |> put_flash(:info, "Invoice created successfully.")
        |> redirect(to: Routes.invoice_path(conn, :show, invoice))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, company_id) do
    case Invoices.get_invoice(id) do
      nil ->
        index(conn, %{}, company_id)

      invoice ->
        cond do
          company_id == invoice.company_id ->
            changeset = Invoices.change_invoice(invoice)
            render(conn, "show.html", invoice: invoice, changeset: changeset)

          true ->
            index(conn, {}, company_id)
        end
    end
  end

  def update(conn, %{"id" => id, "invoice" => invoice_params}, company_id) do
    case Invoices.get_invoice(id) do
      nil ->
        index(conn, %{}, company_id)

      invoice ->
        cond do
          company_id == invoice.company_id ->
            case Invoices.update_invoice(invoice, invoice_params) do
              {:ok, invoice} ->
                conn
                |> put_flash(:info, "Invoice updated successfully.")
                |> redirect(to: Routes.invoice_path(conn, :show, invoice))

              {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "show.html",
                invoice: invoice,
                  changeset: changeset
                )
            end

          true ->
            index(conn, %{}, company_id)
        end
    end
  end

  def delete(conn, %{"id" => id}, company_id) do
    case Invoices.get_invoice(id) do
      nil ->
        index(conn, %{}, company_id)

      invoice ->
        cond do
          company_id == invoice.company_id ->
            {:ok, _invoice} = Invoices.delete_invoice(invoice)

          true ->
            index(conn, %{}, company_id)
        end
    end

    conn
    |> put_flash(:info, "Invoice deleted successfully.")
    |> redirect(to: Routes.invoice_path(conn, :index))
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company.id]
    apply(__MODULE__, action_name(conn), args)
  end
end
