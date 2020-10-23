defmodule Infin.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Infin.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Qwerty1234567890"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password(),
        name: "#{System.unique_integer()}",
        nif: "#{System.unique_integer()}"
      })
      |> Infin.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
