defmodule Infin.Repo.Migrations.TransactionAlterAmount do
  use Ecto.Migration
  import Ecto.Query

  def change do
    amounts =
      "transactions"
      |> select([:id, :amount])
      |> Infin.Repo.all()
      |> Enum.reduce(%{}, fn transaction, acc ->
        Map.put(acc, transaction.id, List.first(transaction.amount))
      end)

    alter table(:transactions) do
      remove :amount
      add :amount, :integer
    end

    amounts
    |> Enum.each(fn {id, amount} ->
         "transactions"
         |> where(id: ^id)
         |> update(set: [amount: ^amount])
         |> Repo.update_all()
    end)
  end
end
