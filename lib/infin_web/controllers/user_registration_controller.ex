defmodule InfinWeb.UserRegistrationController do
  use InfinWeb, :controller

  alias Infin.Accounts
  alias Infin.Accounts.User
  alias Infin.Companies
  alias InfinWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"company" => user_params}), do: create(conn, %{"user" => user_params})
  def create(conn, %{"user" => user_params}) do
    case Companies.create_company(user_params) do
      {:ok, company} ->
        attrs = Map.put(user_params, "company_id", "#{company.id}")

        case Accounts.register_user(attrs) do
          {:ok, user} ->
            {:ok, _} =
              Accounts.deliver_user_confirmation_instructions(
                user,
                &Routes.user_confirmation_url(conn, :confirm, &1)
              )

            conn
            |> put_flash(:info, "User created successfully.")
            |> UserAuth.log_in_user(user)

          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, _} = Companies.delete_company(company)
            render(conn, "new.html", changeset: changeset)
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
