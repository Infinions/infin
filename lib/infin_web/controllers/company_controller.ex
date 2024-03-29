defmodule InfinWeb.CompanyController do
  use InfinWeb, :controller

  alias Infin.Companies

  def show(conn, _params, current_user_company) do
    changeset = Companies.change_company(current_user_company)
    render(conn, "show.html", company: current_user_company, changeset: changeset)
  end

  def update(conn, %{"company" => company_params}, current_user_company) do
    case Companies.update_company(current_user_company, company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: Routes.company_path(conn, :show, company))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "show.html", company: current_user_company, changeset: changeset)
    end
  end

  def action(conn, _) do
    args = [
      conn,
      conn.params,
      conn.assigns.current_user.company
      |> Companies.preload_company_categories()
      |> Companies.preload_company_tags()
    ]

    apply(__MODULE__, action_name(conn), args)
  end
end
