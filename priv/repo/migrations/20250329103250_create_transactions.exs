defmodule FamilyBank.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :transaction_type, :string, null: false
      add :amount, :decimal, precision: 15, scale: 2, null: false
      add :description, :text
      add :timestamp, :naive_datetime, default: fragment("NOW()"), null: false
      add :balance_after_transaction, :decimal, precision: 15, scale: 2, null: false

      timestamps()
    end

    create constraint(:transactions, :amount_must_be_positive,
             check: "amount > 0"
           )

    create constraint(:transactions, :valid_transaction_type,
             check: "transaction_type IN ('credit', 'debit', 'interest')"
           )
  end
end
