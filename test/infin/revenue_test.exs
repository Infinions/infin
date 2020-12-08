defmodule Infin.RevenueTest do
  use Infin.DataCase

  alias Infin.Revenue

  describe "income" do
    alias Infin.Revenue.Income

    @valid_attrs %{date: "some date", description: "some description", value: 42}
    @update_attrs %{date: "some updated date", description: "some updated description", value: 43}
    @invalid_attrs %{date: nil, description: nil, value: nil}

    def income_fixture(attrs \\ %{}) do
      {:ok, income} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Revenue.create_income()

      income
    end

    test "list_income/0 returns all income" do
      income = income_fixture()
      assert Revenue.list_income() == [income]
    end

    test "get_income!/1 returns the income with given id" do
      income = income_fixture()
      assert Revenue.get_income!(income.id) == income
    end

    test "create_income/1 with valid data creates a income" do
      assert {:ok, %Income{} = income} = Revenue.create_income(@valid_attrs)
      assert income.date == "some date"
      assert income.description == "some description"
      assert income.value == 42
    end

    test "create_income/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Revenue.create_income(@invalid_attrs)
    end

    test "update_income/2 with valid data updates the income" do
      income = income_fixture()
      assert {:ok, %Income{} = income} = Revenue.update_income(income, @update_attrs)
      assert income.date == "some updated date"
      assert income.description == "some updated description"
      assert income.value == 43
    end

    test "update_income/2 with invalid data returns error changeset" do
      income = income_fixture()
      assert {:error, %Ecto.Changeset{}} = Revenue.update_income(income, @invalid_attrs)
      assert income == Revenue.get_income!(income.id)
    end

    test "delete_income/1 deletes the income" do
      income = income_fixture()
      assert {:ok, %Income{}} = Revenue.delete_income(income)
      assert_raise Ecto.NoResultsError, fn -> Revenue.get_income!(income.id) end
    end

    test "change_income/1 returns a income changeset" do
      income = income_fixture()
      assert %Ecto.Changeset{} = Revenue.change_income(income)
    end
  end
end
