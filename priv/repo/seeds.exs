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
alias Infin.Invoices.Tag
alias Infin.Repo
alias Infin.Revenue.Income

if User |> Repo.aggregate(:count, :id) > 0 do
  exit(:shutdown)
end

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
  %Tag{}
  |> Tag.changeset(%{"name" => "Election Day", "company_id" => "1"})
)

Repo.insert!(
  %Tag{}
  |> Tag.changeset(%{"name" => "Parking tickets", "company_id" => "1"})
)

Repo.insert!(
  %Tag{}
  |> Tag.changeset(%{"name" => "Office chairs", "company_id" => "2"})
)

Repo.insert!(
  %Tag{}
  |> Tag.changeset(%{"name" => "Christmas Party", "company_id" => "2"})
)

Repo.insert!(
  %Income{}
  |> Income.changeset(%{
    "value" => 100000,
    "date" => Timex.today |> Timex.shift(months: -3) |> Timex.format!("%F", :strftime),
    "description" => "Salary",
    "company_id" => "1"
  })
)

Repo.insert!(
  %Income{}
  |> Income.changeset(%{
    "value" => 50000,
    "date" => Timex.today |> Timex.shift(months: -2) |> Timex.format!("%F", :strftime),
    "description" => "Social Security",
    "company_id" => "1"
  })
)

Repo.insert!(
  %Income{}
  |> Income.changeset(%{
    "value" => 123500,
    "date" => Timex.today |> Timex.shift(months: -1) |> Timex.format!("%F", :strftime),
    "description" => "Stocks",
    "company_id" => "1"
  })
)
