defmodule FamilyBank.Accounts do
  import Ecto.Query, warn: false
  alias FamilyBank.Repo
  alias FamilyBank.Transaction

  def list_transactions do
    Transaction
    |> order_by(asc: :timestamp)
    |> Repo.all()
  end

  def get_current_balance do
    case Repo.one(from t in Transaction, order_by: [desc: :timestamp], limit: 1, select: t.balance_after_transaction) do
      nil -> Decimal.new(0)
      balance -> balance
    end
  end

  def create_transaction(attrs \\ %{}) do
    current_balance = get_current_balance()
    transaction_type = attrs["transaction_type"] || attrs[:transaction_type]

    new_balance =
      case transaction_type do
        "credit" -> Decimal.add(current_balance, Decimal.new(attrs["amount"]))
        "debit" -> Decimal.sub(current_balance, Decimal.new(attrs["amount"]))
        "interest" -> Decimal.add(current_balance, Transaction.calculate_interest(%{balance_after_transaction: current_balance}))
      end

    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Ecto.Changeset.put_change(:balance_after_transaction, new_balance)
    |> Ecto.Changeset.put_change(:timestamp, NaiveDateTime.utc_now())
    |> Repo.insert()
  end
end
