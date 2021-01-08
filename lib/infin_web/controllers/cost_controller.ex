defmodule InfinWeb.CostController do
  use InfinWeb, :controller

  alias Infin.Costs
  alias Infin.Costs.Cost

  def index(conn, params, company_id) do
    page = Infin.Costs.list_costs(params, company_id)
    render(conn, "index.html", costs: page.entries, page: page)
  end

  def new(conn, _params, _company_id) do
    changeset = Costs.change_cost(%Cost{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"cost" => cost_params}, company_id) do
    value = Decimal.new(cost_params["value"]) |> Decimal.mult(100) |> Decimal.round(0, :ceiling) |> Decimal.to_integer
    cost_params = Map.replace!(cost_params, "value", value)
    case Costs.create_cost(cost_params, company_id) do
      {:ok, cost} ->
        conn
        |> put_flash(:info, "Cost created successfully.")
        |> redirect(to: Routes.cost_path(conn, :show, cost))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, company_id) do
    case Infin.Costs.get_cost!(id) do
      nil ->
        index(conn, %{"page" => 1}, company_id)

      cost ->
        cond do
          company_id == cost.company_id ->
            changeset = Infin.Costs.change_cost(cost)
            render(conn, "show.html", cost: cost, changeset: changeset)

          true ->
            index(conn, %{"page" => 1}, company_id)
        end
    end
  end

  def update(conn, %{"id" => id, "cost" => cost_params}, company_id) do
    case Infin.Costs.get_cost(id) do
      nil ->
        index(conn, %{"page" => 1}, company_id)

      cost ->
        cond do
          company_id == cost.company_id ->
            value = Decimal.new(cost_params["value"]) |> Decimal.mult(100) |> Decimal.round(0, :ceiling) |> Decimal.to_integer
            cost_params = Map.replace!(cost_params, "value", value)

            case Infin.Costs.update_cost(cost, cost_params) do
              {:ok, cost} ->
                conn
                |> put_flash(:info, "Cost updated successfully.")
                |> redirect(to: Routes.cost_path(conn, :show, cost))

              {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "show.html",
                  cost: cost,
                  changeset: changeset
                )
            end

          true ->
            index(conn, %{"page" => 1}, company_id)
        end
    end
  end

  def delete(conn, %{"id" => id}, company_id) do
    case Infin.Costs.get_cost(id) do
      nil ->
        index(conn, %{}, company_id)

      cost ->
        cond do
          company_id == cost.company_id ->
            {:ok, _cost} = Infin.Costs.delete_cost(cost)

          true ->
            index(conn, %{}, company_id)
        end
    end

    conn
    |> put_flash(:info, "Cost deleted successfully.")
    |> redirect(to: Routes.cost_path(conn, :index))
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company.id]
    apply(__MODULE__, action_name(conn), args)
  end
end
