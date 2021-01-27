defmodule InfinWeb.Router do
  use InfinWeb, :router

  import InfinWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {InfinWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", InfinWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/metrics", metrics: InfinWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", InfinWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", InfinWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email


    live "/pt/bank_accounts", BankAccountPTLive.Index, :index
    live "/pt/bank_accounts/banks", BankAccountPTLive.Banks, :index
    live "/pt/bank_accounts/consents", BankAccountPTLive.Consents, :index
    live "/pt/bank_accounts/accounts", BankAccountPTLive.Accounts, :index

    live "/dashboard", DashboardLive.Dashboard, :index
  end

  scope "/", InfinWeb do
    pipe_through [:browser]

    get "/", HomeController, :index

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  scope "/manage", InfinWeb do
    pipe_through [:browser, :require_authenticated_user]

    post "/pt/invoices/import", InvoiceImporterController, :import_invoices_pt
    put "/companies/user", AddUserToCompanyController, :add_user
    post "/pt/saft/import", SaftParserController, :import_saft_pt

    resources "/companies", CompanyController, only: [:show, :update]
    resources "/invoices", InvoiceController
    resources "/tags", TagController, except: [:edit]
    resources "/categories", CategoryController, except: [:index, :edit]
    resources "/incomes", IncomeController
    resources "/costs", CostController
    resources "/budgets", BudgetController, except: [:edit]

  end
end
