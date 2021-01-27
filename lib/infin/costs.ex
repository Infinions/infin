defmodule Infin.Costs do
  @moduledoc """
  The Costs context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.Costs.Cost

  @doc """
  Returns the list of costs.

  ## Examples

      iex> list_costs()
      [%Cost{}, ...]

  """
  def list_costs do
    Repo.all(Cost)
  end

  def list_costs(params, company_id) do
    query =
      from(c in Cost,
        where: c.company_id == ^company_id
      )

    Repo.paginate(query, params)
  end

  @doc """
  Gets a single cost.

  Raises `Ecto.NoResultsError` if the Cost does not exist.

  ## Examples

      iex> get_cost!(123)
      %Cost{}

      iex> get_cost!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cost!(id), do: Repo.get!(Cost, id)

  def get_cost(id), do: Repo.get(Cost, id)

  @doc """
  Creates a cost.

  ## Examples

      iex> create_cost(%{field: value})
      {:ok, %Cost{}}

      iex> create_cost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cost(attrs \\ %{}) do
    %Cost{}
    |> Cost.changeset(attrs)
    |> Repo.insert()
  end

  def create_cost(attrs, company_id) do
    cost = %{
      :value => attrs["value"],
      :date => attrs["date"],
      :description => attrs["description"],
      :company_id => company_id
    }

    %Cost{}
    |> Cost.changeset(cost)
    |> Repo.insert()
  end

  @doc """
  Updates a cost.

  ## Examples

      iex> update_cost(cost, %{field: new_value})
      {:ok, %Cost{}}

      iex> update_cost(cost, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cost(%Cost{} = cost, attrs) do
    cost
    |> Cost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cost.

  ## Examples

      iex> delete_cost(cost)
      {:ok, %Cost{}}

      iex> delete_cost(cost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cost(%Cost{} = cost) do
    Repo.delete(cost)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cost changes.

  ## Examples

      iex> change_cost(cost)
      %Ecto.Changeset{data: %Cost{}}

  """
  def change_cost(%Cost{} = cost, attrs \\ %{}) do
    Cost.changeset(cost, attrs)
  end

  def get_monthly_costs(company_id) do
    date = Timex.today
    current_month = date |> Timex.format!("%Y-%m-", :strftime)
    previous_month = date |> Timex.shift(months: -1) |> Timex.format!("%Y-%m-", :strftime)

    previous = Cost
    |> where([i],
        ilike(i.date, ^"%#{previous_month}%")
        and
        i.company_id == ^company_id
      )
    |> Repo.aggregate(:sum, :value)
    || 0

    current = Cost
    |> where([i],
        ilike(i.date, ^"%#{current_month}%")
        and
        i.company_id == ^company_id
      )
    |> Repo.aggregate(:sum, :value)
    || 0

    {current, previous}
  end
end
