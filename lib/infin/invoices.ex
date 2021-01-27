defmodule Infin.Invoices do
  @moduledoc """
  The Invoices context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.Invoices.Invoice
  alias Infin.Invoices.Tag
  alias Infin.Companies
  alias Infin.BankAccounts.PT.InvoiceTransaction

  @doc """
  Returns the list of invoices.

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def list_invoices() do
    Repo.all(Invoice)
  end

  def list_invoices(params) do
    Invoice
    |> Repo.paginate(params)
  end

  def list_company_invoices(company_id, params) do
    query =
      from(i in Invoice,
        where: i.company_id == ^company_id,
        preload: [:company_seller, :category, :company, company: :categories],
        order_by: [desc: :doc_emission_date]
      )

    Repo.paginate(query, params)
  end

  def list_company_invoices_unassociated(company_id, page_number) do
    Invoice
    |> where(company_id: ^company_id)
    |> join(:left, [i], ti in InvoiceTransaction,
      on: i.id == ti.invoice_id
    )
    |> where([i, ti], is_nil(ti.invoice_id))
    |> preload([:company_seller])
    |> Repo.paginate(page: page_number)
  end

  def get_invoices_per_category(company_id, category_id) do
    Invoice
    |> where(company_id: ^company_id)
    |> where(category_id: ^category_id)
    |> Repo.all()
  end

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice!(id), do: Repo.get!(Invoice, id)

  def get_invoice(id), do: Repo.get(Invoice, id)

  def get_invoice_with_relations(id) do
    id
    |> get_invoice()
    |> Repo.preload([:company_seller, :tags, :category, :pdf])
  end

  @doc """
  Creates a invoice.

  ## Examples

      iex> create_invoice(%{field: value})
      {:ok, %Invoice{}}

      iex> create_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invoice(attrs \\ %{}) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end

  def create_invoice(attrs, company_id) do
    unless Companies.get_company_by_nif(attrs["company_seller"]["nif"]) do
      Companies.create_company(%{
        :nif => to_string(attrs["company_seller"]["nif"]),
        :name => attrs["company_seller"]["name"]
      })
    end

    invoice = %{
      :id_document => attrs["id_document"],
      :total_value => attrs["total_value"],
      :doc_emission_date => attrs["doc_emission_date"],
      :company_id => company_id,
      :company_seller_id =>
        Companies.get_company_by_nif(to_string(attrs["company_seller"]["nif"])).id,
      :category_id => attrs["category_id"],
      :pdf_id => attrs["pdf_id"]
    }

    %Invoice{}
    |> Invoice.changeset(invoice)
    |> Repo.insert()
  end

  @spec insert_fectched_invoices_pt(any, any) :: [any]
  def insert_fectched_invoices_pt(invoices, company_id) do
    Enum.map(invoices, fn invoice ->
      unless Companies.get_company_by_nif(to_string(invoice["nifEmitente"])) do
        Companies.create_company(%{
          :nif => to_string(invoice["nifEmitente"]),
          :name => HtmlEntities.decode(invoice["nomeEmitente"])
        })
      end

      document = %{
        :id_document => to_string(invoice["idDocumento"]),
        :total_value => invoice["valorTotal"],
        :doc_emission_date => invoice["dataEmissaoDocumento"],
        :company_id => company_id,
        :company_seller_id => Companies.get_company_by_nif(to_string(invoice["nifEmitente"])).id,
        :category_id => Map.get(invoice, :category_id),
        :automatic_category => Map.get(invoice, :automatic_category)
      }

      create_invoice(document)
    end)
  end

  @doc """
  Updates a invoice.

  ## Examples

      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice(%Invoice{} = invoice, attrs) do
    at = attrs
      |> Map.new(fn {k, v} -> {to_string(k), v} end)
      |> Map.put("automatic_category", false)

    invoice
    |> Invoice.changeset(at)
    |> Repo.update()
  end

  @doc """
  Deletes a invoice.

  ## Examples

      iex> delete_invoice(invoice)
      {:ok, %Invoice{}}

      iex> delete_invoice(invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change_invoice(invoice)
      %Ecto.Changeset{data: %Invoice{}}

  """
  def change_invoice(%Invoice{} = invoice, attrs \\ %{}) do
    Invoice.changeset(invoice, attrs)
  end

  alias Infin.Invoices.Tag

  @doc false
  def list_company_tags(company_id) do
    Repo.all(from t in Tag, where: t.company_id == ^company_id)
  end

  @doc """
  Returns the list of tag.

  ## Examples

      iex> list_tag()
      [%Tag{}, ...]

  """
  def list_tag do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  def get_tag(id), do: Repo.get(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def create_tag(attrs, company_id) do
    tag = %{:name => attrs["name"], :company_id => company_id}

    %Tag{}
    |> Tag.changeset(tag)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  def change_tag_company(tag, company) do
    tag
    |> Repo.preload(:company)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:company, company)
    |> Repo.update!()
  end

  def get_monthly_invoices(company_id) do
    date = Timex.today
    current_month = date |> Timex.format!("%Y-%m-", :strftime)
    previous_month = date |> Timex.shift(months: -1) |> Timex.format!("%Y-%m-", :strftime)

    previous = Invoice
    |> where([i],
        ilike(i.doc_emission_date, ^"%#{previous_month}%")
        and
        i.company_id == ^company_id
      )
    |> Repo.aggregate(:sum, :total_value)
    || 0

    current = Invoice
    |> where([i],
        ilike(i.doc_emission_date, ^"%#{current_month}%")
        and
        i.company_id == ^company_id
      )
    |> Repo.aggregate(:sum, :total_value)
    || 0

    {current, previous}
  end
end
