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
      id_document: sequence("123")
    }
  end

  def tag_factory do
    %Tag{
      name: sequence("Tag"),
      company_id: build(:company)
    }
  end
end
