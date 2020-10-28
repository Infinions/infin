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
alias Infin.Companies.Category
alias Infin.Repo

Repo.insert!(
  %User{}
  |> User.registration_changeset(%{
    "email" => "test1@mail.com",
    "password" => "Qwerty1234567891",
    "name" => "Infin",
    "nif" => "1234"
  })
)

Repo.insert!(
  %User{}
  |> User.registration_changeset(%{
    "email" => "test2@mail.com",
    "password" => "Qwerty1234567892",
    "name" => "NotInfin",
    "nif" => "6123"
  })
)

Repo.insert!(
  %Category{}
  |> Category.changeset(%{"name" => "Food", "company_id" => "1"})
)

Repo.insert!(
  %Category{}
  |> Category.changeset(%{"name" => "Drink", "company_id" => "1"})
)

Repo.insert!(
  %Category{}
  |> Category.changeset(%{"name" => "Education", "company_id" => "2"})
)

Repo.insert!(
  %Category{}
  |> Category.changeset(%{"name" => "Travel", "company_id" => "2"})
)
