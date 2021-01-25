defmodule Infin.Revenue do
  @moduledoc """
  The Revenue context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.Revenue.Income

  @doc """
  Returns the list of income.

  ## Examples

      iex> list_income()
      [%Income{}, ...]

  """
  def list_income do
    Repo.all(Income)
  end

  def list_income(params, company_id) do
    query =
      from(i in Income,
        where: i.company_id == ^company_id
      )

    Repo.paginate(query, params)
  end

  @doc """
  Gets a single income.

  Raises `Ecto.NoResultsError` if the Income does not exist.

  ## Examples

      iex> get_income!(123)
      %Income{}

      iex> get_income!(456)
      ** (Ecto.NoResultsError)

  """
  def get_income!(id), do: Repo.get!(Income, id)

  def get_income(id), do: Repo.get(Income, id)

  @doc """
  Creates a income.

  ## Examples

      iex> create_income(%{field: value})
      {:ok, %Income{}}

      iex> create_income(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_income(attrs \\ %{}) do
    %Income{}
    |> Income.changeset(attrs)
    |> Repo.insert()
  end

  def create_income(attrs, company_id) do
    income = %{
      :value => attrs["value"],
      :date => attrs["date"],
      :description => attrs["description"],
      :company_id => company_id
    }

    %Income{}
    |> Income.changeset(income)
    |> Repo.insert()
  end

  @doc """
  Updates a income.

  ## Examples

      iex> update_income(income, %{field: new_value})
      {:ok, %Income{}}

      iex> update_income(income, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_income(%Income{} = income, attrs) do
    income
    |> Income.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a income.

  ## Examples

      iex> delete_income(income)
      {:ok, %Income{}}

      iex> delete_income(income)
      {:error, %Ecto.Changeset{}}

  """
  def delete_income(%Income{} = income) do
    Repo.delete(income)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking income changes.

  ## Examples

      iex> change_income(income)
      %Ecto.Changeset{data: %Income{}}

  """
  def change_income(%Income{} = income, attrs \\ %{}) do
    Income.changeset(income, attrs)
  end

  def get_monthly_income(company_id) do
    date = Timex.today
    current_month = date |> Timex.format!("%Y-%m-", :strftime)
    previous_month = date |> Timex.shift(months: -1) |> Timex.format!("%Y-%m-", :strftime)

    previous = Income
    |> where([i],
        ilike(i.date, ^"%#{previous_month}%")
        and
        i.company_id == ^company_id
      )
    |> Repo.aggregate(:sum, :value)
    || 0

    current = Income
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
