defmodule Infin.CompaniesTest do
  use Infin.DataCase

  import Infin.Factory

  alias Infin.Companies

  describe "companies" do
    alias Infin.Companies.Company

    @valid_attrs %{name: "some name", nif: "1234"}
    @update_attrs %{name: "some updated name", nif: "123"}
    @invalid_attrs %{nif: nil, name: nil}

    def company_fixture() do
      insert(:company)
    end

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "get_company_by_nif!/1 returns the company with given nif" do
      company = company_fixture()
      assert Companies.get_company_by_nif!(company.nif) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.name == "some name"
      assert company.nif == "1234"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)
      assert company.name == "some updated name"
      assert company.nif == "123"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end

  describe "categories" do
    alias Infin.Companies.Category

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil, company_id: nil}

    def category_fixture() do
      company = insert(:company)
      insert(:category, company_id: company.id)
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Companies.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Companies.get_category(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      company = company_fixture()
      attrs =%{name: "some name", company_id: company.id}
      assert {:ok, %Category{} = category} = Companies.create_category(attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Companies.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_category(category, @invalid_attrs)
      assert category == Companies.get_category(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Companies.delete_category(category)
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Companies.change_category(category)
    end
  end
end
