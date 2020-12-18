defmodule Infin.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset
  alias Infin.Invoices.Tag

  schema "invoices" do
    field :id_document, :string
    field :registration_orig, :string
    field :registration_orig_desc, :string
    field :doc_type, :string
    field :doc_type_dec, :string
    field :doc_number, :string
    field :doc_hash, :string
    field :doc_emission_date, :string
    field :total_value, :integer
    field :total_base_value, :integer
    field :total_tax_value, :integer
    field :total_benef_prov_value, :integer
    field :total_benef_sector_value, :integer
    field :total_gen_exp_value, :integer
    field :benef_state, :string
    field :benef_state_desc, :string
    field :benef_state_emit, :string
    field :benef_state_emit_desc, :string
    field :normal_tax_exists, :boolean
    field :emit_activity, :string
    field :emit_activity_desc, :string
    field :prof_activity, :string
    field :prof_activity_desc, :string
    field :merchant_comm, :boolean
    field :consumer_comm, :boolean
    field :is_foreign, :boolean

    belongs_to :company_seller, Infin.Companies.Company, foreign_key: :company_seller_id
    belongs_to :company, Infin.Companies.Company, foreign_key: :company_id
    belongs_to :category, Infin.Companies.Category
    many_to_many :tags, Tag, join_through: "invoices_tags"

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [
      :id_document,
      :registration_orig,
      :registration_orig_desc,
      :doc_type,
      :doc_type_dec,
      :doc_number,
      :doc_hash,
      :doc_emission_date,
      :total_value,
      :total_base_value,
      :total_tax_value,
      :total_benef_prov_value,
      :total_benef_sector_value,
      :total_gen_exp_value,
      :benef_state,
      :benef_state_desc,
      :benef_state_emit,
      :benef_state_emit_desc,
      :normal_tax_exists,
      :emit_activity,
      :emit_activity_desc,
      :prof_activity,
      :prof_activity_desc,
      :merchant_comm,
      :consumer_comm,
      :is_foreign,
      :company_id,
      :company_seller_id,
      :category_id
    ])
    |> validate_required([:id_document, :doc_emission_date, :total_value, :company_id])
    |> unique_constraint(:id_document)
  end
end
