defmodule Infin.Budgets do
  @moduledoc """
  The Budgets context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.Budgets.Budget
  alias Infin.Invoices

  @doc """
  Returns the list of budgets.

  ## Examples

      iex> list_budgets()
      [%Budget{}, ...]

  """
  def list_budgets do
    Repo.all(Budget)
  end

  def list_budgets(params, company_id) do
    query =
      from(b in Budget,
        where: b.company_id == ^company_id,
        preload: [:category]
      )

    Repo.paginate(query, params)
  end

  def get_budget_spent_value(budget) do
    value = 0
    init_split = String.split(budget.init_date, "-")
    end_split = String.split(budget.end_date, "-")

    init_date =
      Date.new!(
        String.to_integer(Enum.at(init_split, 0)),
        String.to_integer(Enum.at(init_split, 1)),
        String.to_integer(Enum.at(init_split, 2))
      )

    end_date =
      Date.new!(
        String.to_integer(Enum.at(end_split, 0)),
        String.to_integer(Enum.at(end_split, 1)),
        String.to_integer(Enum.at(end_split, 2))
      )

    invoices_per_category =
      Invoices.get_invoices_per_category(budget.company_id, budget.category_id)

    for invoice <- invoices_per_category do
      date_split = String.split(invoice.doc_emission_date, "-")

      date =
        Date.new!(
          String.to_integer(Enum.at(date_split, 0)),
          String.to_integer(Enum.at(date_split, 1)),
          String.to_integer(Enum.at(date_split, 2))
        )

      if !(Date.compare(init_date, date) == :gt or
             Date.compare(end_date, date) == :lt) do
        value = value + invoice.total_value
      end
    end
  end

  @doc """
  Gets a single budget.

  Raises `Ecto.NoResultsError` if the Budget does not exist.

  ## Examples

      iex> get_budget!(123)
      %Budget{}

      iex> get_budget!(456)
      ** (Ecto.NoResultsError)

  """
  def get_budget!(id), do: Repo.get!(Budget, id)

  def get_budget(id), do: Repo.get(Budget, id)

  @doc """
  Creates a budget.

  ## Examples

      iex> create_budget(%{field: value})
      {:ok, %Budget{}}

      iex> create_budget(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_budget(attrs \\ %{}) do
    %Budget{}
    |> Budget.changeset(attrs)
    |> Repo.insert()
  end

  def create_budget(attrs, company_id) do
    budget = %{
      :value => attrs["value"],
      :init_date => attrs["init_date"],
      :end_date => attrs["end_date"],
      :company_id => company_id,
      :category_id => attrs["category_id"]
    }

    %Budget{}
    |> Budget.changeset(budget)
    |> Repo.insert()
  end

  @doc """
  Updates a budget.

  ## Examples

      iex> update_budget(budget, %{field: new_value})
      {:ok, %Budget{}}

      iex> update_budget(budget, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_budget(%Budget{} = budget, attrs) do
    budget
    |> Budget.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a budget.

  ## Examples

      iex> delete_budget(budget)
      {:ok, %Budget{}}

      iex> delete_budget(budget)
      {:error, %Ecto.Changeset{}}

  """
  def delete_budget(%Budget{} = budget) do
    Repo.delete(budget)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking budget changes.

  ## Examples

      iex> change_budget(budget)
      %Ecto.Changeset{data: %Budget{}}

  """
  def change_budget(%Budget{} = budget, attrs \\ %{}) do
    Budget.changeset(budget, attrs)
  end
end
