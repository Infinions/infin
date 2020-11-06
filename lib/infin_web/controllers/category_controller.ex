defmodule InfinWeb.CategoryController do
  use InfinWeb, :controller

  alias Infin.Companies
  alias Infin.Companies.Category

  def index(conn, _params, company_id) do
    categories = Companies.list_company_categories(company_id)
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params, _company_id) do
    changeset = Companies.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}, company_id) do
    case Companies.create_category(category_params, company_id) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: Routes.company_path(conn, :show, Companies.get_company!(company_id)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, company_id) do
    case Companies.get_category(id) do
      nil ->
        index(conn, %{}, company_id)

      category ->
        cond do
          company_id == category.company_id ->
            changeset = Companies.change_category(category)
            render(conn, "show.html", category: category, changeset: changeset)

          true ->
            index(conn, %{}, company_id)
        end
    end
  end

  def update(conn, %{"id" => id, "category" => category_params}, company_id) do
    case Companies.get_category(id) do
      nil ->
        index(conn, %{}, company_id)

      category ->
        cond do
          company_id == category.company_id ->
            case Companies.update_category(category, category_params) do
              {:ok, _category} ->
                conn
                |> put_flash(:info, "Category updated successfully.")
                |> redirect(to: Routes.company_path(conn, :show, Companies.get_company!(company_id)))

              {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "show.html", category: category, changeset: changeset)
            end

          true ->
            index(conn, %{}, company_id)
        end
    end
  end

  def delete(conn, %{"id" => id}, company_id) do
    case Companies.get_category(id) do
      nil ->
        index(conn, %{}, company_id)

      category ->
        cond do
          company_id == category.company_id ->
            {:ok, _category} = Companies.delete_category(category)

          true ->
            index(conn, %{}, company_id)
        end
    end

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.company_path(conn, :show, Companies.get_company!(company_id)))
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company.id]
    apply(__MODULE__, action_name(conn), args)
  end
end
