defmodule InfinWeb.UserRegistrationController do
  use InfinWeb, :controller

  alias Infin.Accounts
  alias Infin.Accounts.User
  alias Infin.Companies
  alias InfinWeb.UserAuth

  def new(conn, _params) do
    changeset = User.registration_changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
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
        IO.inspect(changeset)
        render(conn, "new.html", changeset: copy_errors(changeset))
    end
  end

  defp copy_errors(%Ecto.Changeset{} = changeset) do
    cond do
      changeset.changes.company.errors ->
        for err <- changeset.changes.company.errors do
          [key | [err | []]] = Tuple.to_list(err)
          changeset = Ecto.Changeset.add_error(changeset, key, err)
        end
        changeset

      true -> changeset
    end
  end
end
