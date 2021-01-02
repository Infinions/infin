defmodule Infin.BankAccounts.PT_Banks do
  @moduledoc """
  The Banks.PT_Banks context.
  """

  import Ecto.Query, warn: false
  alias Infin.Repo

  alias Infin.BankAccounts.PT.Bank

  def list_banks(page_number) do
    Repo.paginate(Bank, page: page_number)
  end

  def get_bank(aspsp_cde) do
    Repo.get_by(Bank, aspsp_cde: aspsp_cde)
  end
end
