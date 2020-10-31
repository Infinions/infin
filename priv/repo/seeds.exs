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
alias Infin.Market.Enterprise
alias Infin.Repo

Repo.insert!(
  %User{}
  |> User.registration_changeset(%{
    "email" => "test1@mail.com",
    "password" => "Qwerty1234567891",
    "company" => %{"name" => "Infin", "nif" => "1234"}
  })
)

Repo.insert!(
  %User{}
  |> User.registration_changeset(%{
    "email" => "test2@mail.com",
    "password" => "Qwerty1234567892",
    "company" => %{
      "name" => "NotInfin",
      "nif" => "6123"
    }
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

Repo.insert!(
  %Enterprise{}
  |> Enterprise.changeset(%{
    "name" => "CESIUM - CENTRO DE ESTUDANTES DE ENGENHARIA INFORMATICA DA UNIVERSIDADE DO MINHO",
    "nif" => "503483222"
  })
)

Repo.insert!(
  %Enterprise{}
  |> Enterprise.changeset(%{
    "name" => "Subvisual Digital Finance, Lda",
    "nif" => "515572535"
  })
)
