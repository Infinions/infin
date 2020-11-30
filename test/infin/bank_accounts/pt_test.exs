defmodule Infin.BankAccounts.PTTest do
  use Infin.DataCase

  alias Infin.BankAccounts.PT

  describe "banks" do
    alias Infin.BankAccounts.PT.Bank

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def bank_fixture(attrs \\ %{}) do
      {:ok, bank} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PT.create_bank()

      bank
    end

    test "list_banks/0 returns all banks" do
      bank = bank_fixture()
      assert PT.list_banks() == [bank]
    end

    test "get_bank!/1 returns the bank with given id" do
      bank = bank_fixture()
      assert PT.get_bank!(bank.id) == bank
    end

    test "create_bank/1 with valid data creates a bank" do
      assert {:ok, %Bank{} = bank} = PT.create_bank(@valid_attrs)
    end

    test "create_bank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PT.create_bank(@invalid_attrs)
    end

    test "update_bank/2 with valid data updates the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{} = bank} = PT.update_bank(bank, @update_attrs)
    end

    test "update_bank/2 with invalid data returns error changeset" do
      bank = bank_fixture()
      assert {:error, %Ecto.Changeset{}} = PT.update_bank(bank, @invalid_attrs)
      assert bank == PT.get_bank!(bank.id)
    end

    test "delete_bank/1 deletes the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{}} = PT.delete_bank(bank)
      assert_raise Ecto.NoResultsError, fn -> PT.get_bank!(bank.id) end
    end

    test "change_bank/1 returns a bank changeset" do
      bank = bank_fixture()
      assert %Ecto.Changeset{} = PT.change_bank(bank)
    end
  end
end
