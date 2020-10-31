defmodule Infin.MarketTest do
  use Infin.DataCase

  alias Infin.Market

  describe "enterprises" do
    alias Infin.Market.Enterprise

    @valid_attrs %{name: "some name", nif: "some nif"}
    @update_attrs %{name: "some updated name", nif: "some updated nif"}
    @invalid_attrs %{name: nil, nif: nil}

    def enterprise_fixture(attrs \\ %{}) do
      {:ok, enterprise} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Market.create_enterprise()

      enterprise
    end

    test "list_enterprises/0 returns all enterprises" do
      enterprise = enterprise_fixture()
      assert Market.list_enterprises() == [enterprise]
    end

    test "get_enterprise!/1 returns the enterprise with given id" do
      enterprise = enterprise_fixture()
      assert Market.get_enterprise!(enterprise.id) == enterprise
    end

    test "create_enterprise/1 with valid data creates a enterprise" do
      assert {:ok, %Enterprise{} = enterprise} = Market.create_enterprise(@valid_attrs)
      assert enterprise.name == "some name"
      assert enterprise.nif == "some nif"
    end

    test "create_enterprise/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_enterprise(@invalid_attrs)
    end

    test "update_enterprise/2 with valid data updates the enterprise" do
      enterprise = enterprise_fixture()
      assert {:ok, %Enterprise{} = enterprise} = Market.update_enterprise(enterprise, @update_attrs)
      assert enterprise.name == "some updated name"
      assert enterprise.nif == "some updated nif"
    end

    test "update_enterprise/2 with invalid data returns error changeset" do
      enterprise = enterprise_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_enterprise(enterprise, @invalid_attrs)
      assert enterprise == Market.get_enterprise!(enterprise.id)
    end

    test "change_enterprise/1 returns a enterprise changeset" do
      enterprise = enterprise_fixture()
      assert %Ecto.Changeset{} = Market.change_enterprise(enterprise)
    end
  end
end
