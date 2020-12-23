defmodule InfinWeb.InvoiceController do
  use InfinWeb, :controller

  alias Infin.Invoices
  alias Infin.Invoices.Invoice
  alias Infin.Companies
  alias Infin.Storage

  def index(conn, params, company_id) do
    page = Invoices.list_company_invoices(company_id, params)
    company = Companies.get_company(company_id)
    render(conn, "index.html", invoices: page.entries, company: company, page: page)
  end

  def new(conn, _params, company_id) do
    changeset = Invoices.change_invoice(%Invoice{})
    categories = Companies.list_company_categories(company_id) |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, categories: categories)
  end

  def create(conn, %{"invoice" => invoice_params}, company_id) do
    total_value =
      Decimal.new(invoice_params["total_value"])
      |> Decimal.mult(100)
      |> Decimal.round(0, :ceiling)
      |> Decimal.to_integer()

    invoice_params = Map.replace!(invoice_params, "total_value", total_value)

    if invoice_params["category_id"] != nil do
        Map.replace!(
          invoice_params,
          "category_id",
          String.to_integer(invoice_params["category_id"])
        )
    end

    invoice_params = check_for_pdf(conn, invoice_params)

    case Invoices.create_invoice(invoice_params, company_id) do
      {:ok, invoice} ->

        conn
        |> put_flash(:info, "Invoice created successfully.")
        |> redirect(to: Routes.invoice_path(conn, :show, invoice))

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Companies.list_company_categories(company_id) |> Enum.map(&{&1.name, &1.id})
        render(conn, "new.html", changeset: changeset, categories: categories)
    end
  end

  def show(conn, %{"id" => id}, company_id) do
    case Invoices.get_invoice_with_relations(id) do
      nil ->
        index(conn, %{"page" => 1}, company_id)

      invoice ->
        cond do
          company_id == invoice.company_id ->
            categories =
              Companies.list_company_categories(company_id) |> Enum.map(&{&1.name, &1.id})

            changeset = Invoices.change_invoice(invoice)
            render(conn, "show.html",
              invoice: invoice,
              changeset: changeset,
              categories: categories
            )

          true ->
            index(conn, %{"page" => 1}, company_id)
        end
    end
  end

  def update(conn, %{"id" => id, "invoice" => invoice_params}, company_id) do
    case Invoices.get_invoice_with_relations(id) do
      nil ->
        index(conn, %{"page" => 1}, company_id)

      invoice ->
        cond do
          company_id == invoice.company_id ->
            total_value =
              Decimal.new(invoice_params["total_value"])
              |> Decimal.mult(100)
              |> Decimal.round(0, :ceiling)
              |> Decimal.to_integer()

            invoice_params = Map.replace!(invoice_params, "total_value", total_value)

            if invoice_params["category_id"] != nil do
              Map.replace!(
                invoice_params,
                "category_id",
                String.to_integer(invoice_params["category_id"])
              )
            end

            invoice_params = check_for_pdf(conn, invoice_params)

            case Invoices.update_invoice(invoice, invoice_params) do
              {:ok, invoice} ->
                IO.inspect(invoice)
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
            index(conn, %{"page" => 1}, company_id)
        end
    end
  end

  def delete(conn, %{"id" => id}, company_id) do
    case Invoices.get_invoice_with_relations(id) do
      nil ->
        index(conn, %{}, company_id)

      invoice ->
        cond do
          company_id == invoice.company_id ->
            {:ok, _pdf} = Pdf.delete(invoice.pdf)
            {:ok, _invoice} = Invoices.delete_invoice(invoice)

          true ->
            index(conn, %{}, company_id)
        end
    end

    conn
    |> put_flash(:info, "Invoice deleted successfully.")
    |> redirect(to: Routes.invoice_path(conn, :index))
  end

  defp check_for_pdf(conn, invoice_params) do
    if Map.has_key?(invoice_params, "pdf") do
      case Storage.create_pdf(%{pdf: invoice_params["pdf"]}) do
        {:ok, pdf} ->
          invoice_params = Map.put(invoice_params, "pdf_id", pdf.id)
          IO.inspect(invoice_params)

        {:error, _changeset} ->
          conn
          |> put_flash(:error, "Error inserting pdf attachment.")
          |> redirect(to: Routes.invoice_path(conn, :new))
      end
    else
      invoice_params
    end
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company.id]

    apply(__MODULE__, action_name(conn), args)
  end
end
