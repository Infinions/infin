defmodule Infin.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo
  alias Ecto.Multi

  alias Infin.Companies.Company
  alias Infin.Accounts.User

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company_by_nif!(123)
      %Company{}

      iex> get_company_by_nif!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company_by_nif!(nif), do: Repo.get_by!(Company, nif: nif)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  @doc """
  Adds an user to ta company.

  ## Examples

      iex> add_user_to_company(company, user)
      {:ok, %Ecto.Schema{}}

      iex> add_user_company(company, bad_user})
      {:error, %Ecto.Changeset{}}

  """
  def add_user_to_company(%Company{} = company, %User{} = user) do
    user
    |> Ecto.Changeset.change(%{company_id: company.id})
    |> Ecto.Changeset.put_assoc(:company, company)
    |> Repo.update()
  end

  def register_user_and_company(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:company, %Company{} |> Company.changeset(attrs))
    |> Multi.run(:user, fn repo, %{company: company} ->
      repo.insert(
        %User{}
        |> User.registration_changeset(attrs)
        |> Ecto.Changeset.change(%{company_id: company.id})
        |> Ecto.Changeset.put_assoc(:company, company)
      )
    end)
    |> Repo.transaction()
  end
end
