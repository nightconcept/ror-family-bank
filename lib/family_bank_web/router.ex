defmodule FamilyBankWeb.Router do
  use FamilyBankWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FamilyBankWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin_auth do
    plug :admin_authenticate
  end

  scope "/", FamilyBankWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/ledger", PageController, :ledger
  end

  scope "/admin", FamilyBankWeb do
    pipe_through [:browser, :admin_auth]

    get "/", AdminController, :index
    post "/login", AdminController, :login
    post "/logout", AdminController, :logout
    post "/transactions/:type", AdminController, :create_transaction
  end

  defp admin_authenticate(conn, _opts) do
    case get_session(conn, :admin_authenticated) do
      true ->
        conn

      _ ->
        conn
        |> Phoenix.Controller.put_flash(:error, "You must be logged in to access this page.")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
    end
  end

  if Application.compile_env(:family_bank, :dev_routes) do
    import Phoenix.LiveDashboard.Router
    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FamilyBankWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
