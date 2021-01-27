defmodule Infin.BudgetsTest do
  use Infin.DataCase

  alias Infin.Budgets

  import Infin.Factory

  describe "budgets" do
    alias Infin.Budgets.Budget

    @update_attrs %{end_date: "some updated end_date", init_date: "some updated init_date", value: 43}
    @invalid_attrs %{end_date: nil, init_date: nil, value: nil}

    def budget_fixture() do
      company = insert(:company)
      category = insert(:category, company_id: company.id)
      insert(:budget, company_id: company.id, category_id: category.id)
    end

    test "list_budgets/0 returns all budgets" do
      budget = budget_fixture()
      assert Budgets.list_budgets() == [budget]
    end

    test "get_budget!/1 returns the budget with given id" do
      budget = budget_fixture()
      assert Budgets.get_budget!(budget.id) == budget
    end

    test "create_budget/1 with valid data creates a budget" do
      company = insert(:company)
      category = insert(:category, company_id: company.id)
      attrs = %{
        init_date: "some date",
        end_date: "some description",
        category_id: category.id,
        value: 42,
        company_id: company.id
      }
      assert {:ok, %Budget{} = budget} = Budgets.create_budget(attrs)
      assert budget.end_date == "some description"
      assert budget.init_date == "some date"
      assert budget.value == 42
    end

    test "create_budget/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Budgets.create_budget(@invalid_attrs)
    end

    test "update_budget/2 with valid data updates the budget" do
      budget = budget_fixture()
      assert {:ok, %Budget{} = budget} = Budgets.update_budget(budget, @update_attrs)
      assert budget.end_date == "some updated end_date"
      assert budget.init_date == "some updated init_date"
      assert budget.value == 43
    end

    test "update_budget/2 with invalid data returns error changeset" do
      budget = budget_fixture()
      assert {:error, %Ecto.Changeset{}} = Budgets.update_budget(budget, @invalid_attrs)
      assert budget == Budgets.get_budget!(budget.id)
    end

    test "delete_budget/1 deletes the budget" do
      budget = budget_fixture()
      assert {:ok, %Budget{}} = Budgets.delete_budget(budget)
      assert_raise Ecto.NoResultsError, fn -> Budgets.get_budget!(budget.id) end
    end

    test "change_budget/1 returns a budget changeset" do
      budget = budget_fixture()
      assert %Ecto.Changeset{} = Budgets.change_budget(budget)
    end
  end
end
