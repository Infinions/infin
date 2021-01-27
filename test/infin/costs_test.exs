defmodule Infin.CostsTest do
  use Infin.DataCase

  alias Infin.Costs

  import Infin.Factory

  describe "costs" do
    alias Infin.Costs.Cost

    @update_attrs %{date: "some updated date", description: "some updated description", value: 43}
    @invalid_attrs %{date: nil, description: nil, value: nil}

    def cost_fixture() do
      company = insert(:company)
      insert(:cost, company_id: company.id)
    end

    test "list_costs/0 returns all costs" do
      cost = cost_fixture()
      assert Costs.list_costs() == [cost]
    end

    test "get_cost!/1 returns the cost with given id" do
      cost = cost_fixture()
      assert Costs.get_cost!(cost.id) == cost
    end

    test "create_cost/1 with valid data creates a cost" do
      company = insert(:company)

      attrs = %{
        date: "some date",
        description: "some description",
        value: 42,
        company_id: company.id
      }
      assert {:ok, %Cost{} = cost} = Costs.create_cost(attrs)
      assert cost.date == "some date"
      assert cost.description == "some description"
      assert cost.value == 42
    end

    test "create_cost/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Costs.create_cost(@invalid_attrs)
    end

    test "update_cost/2 with valid data updates the cost" do
      cost = cost_fixture()
      assert {:ok, %Cost{} = cost} = Costs.update_cost(cost, @update_attrs)
      assert cost.date == "some updated date"
      assert cost.description == "some updated description"
      assert cost.value == 43
    end

    test "update_cost/2 with invalid data returns error changeset" do
      cost = cost_fixture()
      assert {:error, %Ecto.Changeset{}} = Costs.update_cost(cost, @invalid_attrs)
      assert cost == Costs.get_cost!(cost.id)
    end

    test "delete_cost/1 deletes the cost" do
      cost = cost_fixture()
      assert {:ok, %Cost{}} = Costs.delete_cost(cost)
      assert_raise Ecto.NoResultsError, fn -> Costs.get_cost!(cost.id) end
    end

    test "change_cost/1 returns a cost changeset" do
      cost = cost_fixture()
      assert %Ecto.Changeset{} = Costs.change_cost(cost)
    end
  end
end
