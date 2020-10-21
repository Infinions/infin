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
alias Infin.Companies.Company
alias Infin.Companies
alias Infin.Repo

Repo.insert!(
  %Company{}
  |> Company.changeset(%{name: "Infin"})
)

Repo.insert!(
  %Company{}
  |> Company.changeset(%{name: "NotInfin"})
)

Repo.insert!(
  %User{}
  |> User.registration_changeset(%{email: "test1@mail.com", password: "Qwerty1234567891"})
  |> Ecto.Changeset.put_assoc(:company, Companies.get_company!(1))
)

Repo.insert!(
  %User{}
  |> User.registration_changeset(%{email: "test2@mail.com", password: "Qwerty1234567892"})
  |> Ecto.Changeset.put_assoc(:company, Companies.get_company!(2))
)

Repo.insert!(
  %User{}
  |> User.registration_changeset(%{email: "test3@mail.com", password: "Qwerty1234567893"})
  |> Ecto.Changeset.put_assoc(:company, Companies.get_company!(1))
)
