defmodule InfinWeb.AddUserToCompanyController do
  use InfinWeb, :controller

  alias Infin.Accounts

  def add_user(conn, user_params, company) do
    user_params = user_params["company"]
    user_params = Map.put(user_params, "company_id", company.id)
    case Accounts.add_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User created.")
        |> redirect(to: Routes.company_path(conn, :show, company))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error creating user.")
        |> redirect(to: Routes.company_path(conn, :show, company))
    end
  end

  def action(conn, _) do
    args = [
      conn,
      conn.params,
      conn.assigns.current_user.company
    ]

    apply(__MODULE__, action_name(conn), args)
  end
end
