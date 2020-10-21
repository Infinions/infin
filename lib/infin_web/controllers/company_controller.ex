defmodule InfinWeb.CompanyController do
  use InfinWeb, :controller

  alias Infin.Companies
  alias Infin.Companies.Company

  def index(conn, _params, current_user_company) do
    case current_user_company do
      nil ->
        render(conn, "index.html", companies: [])

      _ ->
        companies = [current_user_company]
        render(conn, "index.html", companies: companies)
    end
  end

  def new(conn, _params, _current_user_company) do
    changeset = Companies.change_company(%Company{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"company" => company_params}, _current_user_company) do
    case Companies.create_company(company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: Routes.company_path(conn, :show, company))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user_company) do
    cond do
      current_user_company != nil && "#{current_user_company.id}" == id ->
        company = current_user_company
        render(conn, "show.html", company: company)

      true ->
        redirect(conn, to: Routes.company_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user_company) do
    cond do
      current_user_company != nil && "#{current_user_company.id}" == id ->
        company = current_user_company
        changeset = Companies.change_company(company)
        render(conn, "edit.html", company: company, changeset: changeset)

      true ->
        redirect(conn, to: Routes.company_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "company" => company_params}, current_user_company) do
    cond do
      current_user_company != nil && "#{current_user_company.id}" == id ->
        company = current_user_company

        case Companies.update_company(company, company_params) do
          {:ok, company} ->
            conn
            |> put_flash(:info, "Company updated successfully.")
            |> redirect(to: Routes.company_path(conn, :show, company))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", company: company, changeset: changeset)
        end

      true ->
        redirect(conn, to: Routes.company_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}, current_user_company) do
    cond do
      current_user_company != nil && "#{current_user_company.id}" == id ->
        company = current_user_company
        {:ok, _company} = Companies.delete_company(company)

        conn
        |> put_flash(:info, "Company deleted successfully.")
        |> redirect(to: Routes.company_path(conn, :index))

      true ->
        redirect(conn, to: Routes.company_path(conn, :index))
    end
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company]
    apply(__MODULE__, action_name(conn), args)
  end
end
