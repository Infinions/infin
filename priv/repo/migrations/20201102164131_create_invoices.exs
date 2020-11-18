defmodule Infin.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :id_document, :string
      add :registration_orig, :string
      add :registration_orig_desc, :string
      add :doc_type, :string
      add :doc_type_dec, :string
      add :doc_number, :string
      add :doc_hash, :string
      add :doc_emition_date, :string
      add :total_value, :integer
      add :total_base_value, :integer
      add :total_tax_value, :integer
      add :total_benef_prov_value, :integer
      add :total_benef_sector_value, :integer
      add :total_gen_exp_value, :integer
      add :benef_state, :string
      add :benef_state_desc, :string
      add :benef_state_emit, :string
      add :benef_state_emit_desc, :string
      add :normal_tax_exists, :boolean
      add :emit_activity, :string
      add :emit_activity_desc, :string
      add :prof_activity, :string
      add :prof_activity_desc, :string
      add :merchant_comm, :boolean
      add :consumer_comm, :boolean
      add :is_foreign, :boolean

      timestamps()
    end
  end
end
