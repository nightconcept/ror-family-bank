defmodule FamilyBankWeb.AdminController do
  use FamilyBankWeb, :controller
  alias FamilyBank.Accounts

  def index(conn, _params) do
    render(conn, :index)
  end

  def login(conn, %{"password" => password}) do
    if password == "password" do
      conn
      |> put_session(:admin_authenticated, true)
      |> redirect(to: "/admin")
    else
      conn
      |> put_flash(:error, "Invalid password")
      |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:admin_authenticated)
    |> redirect(to: "/")
  end

  def create_transaction(conn, %{"type" => type} = params) do
    case Accounts.create_transaction(%{
      "transaction_type" => type,
      "amount" => params["amount"],
      "description" => params["description"]
    }) do
      {:ok, _transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully")
        |> redirect(to: "/admin")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create transaction")
        |> redirect(to: "/admin")
    end
  end
end
