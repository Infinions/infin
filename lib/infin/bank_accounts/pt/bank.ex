defmodule Infin.BankAccounts.PT.Bank do
  use Ecto.Schema
  import Ecto.Changeset

  schema "banks" do
    field :aspsp_cde, :string
    field :bank_code, :string
    field :bank_id, :string, null: false
    field :bic, :string
    field :logo_location, :string
    field :name, :string

    has_many :accounts, Infin.BankAccounts.PT.Account

    timestamps()
  end

  @doc false
  def changeset(bank, attrs) do
    bank
    |> cast(attrs, [:bank_id, :bic, :bank_code, :aspsp_cde, :name, :logo_location])
    |> validate_required([:bank_id, :bic, :bank_code, :aspsp_cde, :name, :logo_location])
    |> unique_constraint(:bank_id)
  end
end
