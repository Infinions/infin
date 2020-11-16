defmodule Infin.Factory do
  use ExMachina.Ecto, repo: Infin.Repo

  alias Infin.Companies.{Company, Category}
  alias Infin.Invoices.{Invoice, Tag}

  def company_factory do
    %Company{
      name: sequence("Company"),
      nif: sequence("123456789")
    }
  end

  def category_factory do
    %Category{
      name: sequence("Category"),
      company_id: build(:company)
    }
  end

  def invoice_factory do
    %Invoice{
      id_document: sequence("123"),
      registration_orig: sequence("string"),
      registration_orig_desc: sequence("string"),
      doc_type: sequence("string"),
      doc_type_dec: sequence("string"),
      doc_number: sequence("string"),
      doc_hash: sequence("string"),
      doc_emition_date: sequence("string"),
      total_value: :rand.uniform(100),
      total_base_value: :rand.uniform(80),
      total_tax_value: :rand.uniform(1),
      total_benef_prov_value: :rand.uniform(90),
      total_benef_sector_value: :rand.uniform(90),
      total_gen_exp_value: :rand.uniform(90),
      benef_state: sequence("string"),
      benef_state_desc: sequence("string"),
      benef_state_emit: sequence("string"),
      benef_state_emit_desc: sequence("string"),
      normal_tax_exists: true,
      emit_activity: sequence("string"),
      emit_activity_desc: sequence("string"),
      prof_activity: sequence("string"),
      prof_activity_desc: sequence("string"),
      merchant_comm: false,
      consumer_comm: true,
      is_foreign: true,
      company_seller_id: build(:company),
      company_id: build(:company)
    }
  end

  def tag_factory do
    %Tag{
      name: sequence("Tag"),
      company_id: build(:company)
    }
  end
end
