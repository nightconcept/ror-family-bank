defmodule FamilyBankWeb.PageController do
  use FamilyBankWeb, :controller
  alias FamilyBank.Accounts

  def home(conn, _params) do
    current_balance = Accounts.get_current_balance()
    render(conn, :home, current_balance: current_balance)
  end

  def ledger(conn, _params) do
    transactions = Accounts.list_transactions()
    current_balance = Accounts.get_current_balance()
    render(conn, :ledger, transactions: transactions, current_balance: current_balance)
  end
end
