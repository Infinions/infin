defmodule Infin.Market do
  @moduledoc """
  The Market context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.Market.Enterprise

  @doc """
  Returns the list of enterprises.

  ## Examples

      iex> list_enterprises()
      [%Enterprise{}, ...]

  """
  def list_enterprises do
    Repo.all(Enterprise)
  end

  @doc """
  Gets a single enterprise.

  Raises `Ecto.NoResultsError` if the Enterprise does not exist.

  ## Examples

      iex> get_enterprise!(123)
      %Enterprise{}

      iex> get_enterprise!(456)
      ** (Ecto.NoResultsError)

  """
  def get_enterprise!(id), do: Repo.get!(Enterprise, id)

  @doc """
  Creates a enterprise.

  ## Examples

      iex> create_enterprise(%{field: value})
      {:ok, %Enterprise{}}

      iex> create_enterprise(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_enterprise(attrs \\ %{}) do
    %Enterprise{}
    |> Enterprise.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a enterprise.

  ## Examples

      iex> update_enterprise(enterprise, %{field: new_value})
      {:ok, %Enterprise{}}

      iex> update_enterprise(enterprise, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_enterprise(%Enterprise{} = enterprise, attrs) do
    enterprise
    |> Enterprise.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking enterprise changes.

  ## Examples

      iex> change_enterprise(enterprise)
      %Ecto.Changeset{data: %Enterprise{}}

  """
  def change_enterprise(%Enterprise{} = enterprise, attrs \\ %{}) do
    Enterprise.changeset(enterprise, attrs)
  end
end
