defmodule InfinWeb.IncomeController do
  use InfinWeb, :controller

  alias Infin.Revenue
  alias Infin.Revenue.Income

  def index(conn, params, company_id) do
    page = Revenue.list_income(params, company_id)
    render(conn, "index.html", income: page.entries, page: page)
  end

  def new(conn, _params, _company_id) do
    changeset = Revenue.change_income(%Income{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"income" => income_params}, company_id) do
    case Revenue.create_income(income_params, company_id) do
      {:ok, income} ->
        conn
        |> put_flash(:info, "Income created successfully.")
        |> redirect(to: Routes.income_path(conn, :show, income))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, company_id) do
    case Revenue.get_income!(id) do
      nil ->
        index(conn, %{"page" => 1}, company_id)

      income ->
        cond do
          company_id == income.company_id ->
            changeset = Revenue.change_income(income)
            render(conn, "show.html", income: income, changeset: changeset)

          true ->
            index(conn, %{"page" => 1}, company_id)
        end
    end
  end

  def update(conn, %{"id" => id, "income" => income_params}, company_id) do
    case Revenue.get_income(id) do
      nil ->
        index(conn, %{"page" => 1}, company_id)

      income ->
        cond do
          company_id == income.company_id ->
            case Revenue.update_income(income, income_params) do
              {:ok, income} ->
                conn
                |> put_flash(:info, "Income updated successfully.")
                |> redirect(to: Routes.income_path(conn, :show, income))

              {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "show.html",
                  invoice: income,
                  changeset: changeset
                )
            end

          true ->
            index(conn, %{"page" => 1}, company_id)
        end
    end
  end

  def delete(conn, %{"id" => id}, company_id) do
    case Revenue.get_income(id) do
      nil ->
        index(conn, %{}, company_id)

      income ->
        cond do
          company_id == income.company_id ->
            {:ok, _income} = Revenue.delete_income(income)

          true ->
            index(conn, %{}, company_id)
        end
    end

    conn
    |> put_flash(:info, "Income deleted successfully.")
    |> redirect(to: Routes.income_path(conn, :index))
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company.id]
    apply(__MODULE__, action_name(conn), args)
  end
end
