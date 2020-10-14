# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Infin.Repo.insert!(%Infin.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Infin.Accounts.User
alias Infin.Repo

Repo.insert!(
  %User{}
  |> User.registration_changeset(%{email: "test@mail.com", password: "qwerty1234567891"})
)

Repo.insert!(
  %User{}
  |> User.registration_changeset(%{email: "test2@mail.com", password: "qwerty1234567892"})
)
