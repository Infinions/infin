defmodule InfinWeb.UserRegistrationControllerTest do
  use InfinWeb.ConnCase, async: true

  import Infin.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ "Log in"
      assert response =~ "Register"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => email,
            "password" => valid_user_password(),
            "password_confirmation" => valid_user_password(),
            "company" => %{
              "nif" => "#{System.unique_integer()}",
              "name" => "#{System.unique_integer()}"
            }
          }
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/dashboard")
      response = html_response(conn, 200)
      assert response =~ "Invoices</a>"
      assert response =~ "Incomes</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => "with spaces",
            "password" => "Too short",
            "password_confirmation" => "does not match",
            "company" => %{
              "nif" => "#{System.unique_integer()}",
              "name" => "#{System.unique_integer()}"
            }
          }
        })

      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
      assert response =~ "does not match password"
    end
  end
end
