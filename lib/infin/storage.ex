defmodule Infin.Storage do
  @moduledoc """
  The Storage context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.Storage.Pdf

  @doc """
  Returns the list of pdfs.

  ## Examples

      iex> list_pdfs()
      [%Pdf{}, ...]

  """
  def list_pdfs do
    Repo.all(Pdf)
  end

  @doc """
  Gets a single pdf.

  Raises `Ecto.NoResultsError` if the Pdf does not exist.

  ## Examples

      iex> get_pdf!(123)
      %Pdf{}

      iex> get_pdf!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pdf!(id), do: Repo.get!(Pdf, id)

  @doc """
  Creates a pdf.

  ## Examples

      iex> create_pdf(%{field: value})
      {:ok, %Pdf{}}

      iex> create_pdf(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pdf(attrs \\ %{}) do
    %Pdf{}
    |> Pdf.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pdf.

  ## Examples

      iex> update_pdf(pdf, %{field: new_value})
      {:ok, %Pdf{}}

      iex> update_pdf(pdf, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pdf(%Pdf{} = pdf, attrs) do
    pdf
    |> Pdf.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pdf.

  ## Examples

      iex> delete_pdf(pdf)
      {:ok, %Pdf{}}

      iex> delete_pdf(pdf)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pdf(%Pdf{} = pdf) do
    Repo.delete(pdf)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pdf changes.

  ## Examples

      iex> change_pdf(pdf)
      %Ecto.Changeset{data: %Pdf{}}

  """
  def change_pdf(%Pdf{} = pdf, attrs \\ %{}) do
    Pdf.changeset(pdf, attrs)
  end
end
