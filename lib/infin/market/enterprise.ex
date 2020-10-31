defmodule Infin.Market.Enterprise do
  use Ecto.Schema
  import Ecto.Changeset

  schema "enterprises" do
    field :name, :string
    field :nif, :string

    timestamps()
  end

  @doc false
  def changeset(enterprise, attrs) do
    enterprise
    |> cast(attrs, [:name, :nif])
    |> validate_required([:name, :nif])
    |> unique_constraint(:nif)
  end
end
