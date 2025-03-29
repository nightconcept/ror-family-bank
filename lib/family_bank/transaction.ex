defmodule FamilyBank.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_types ~w(credit debit interest)

  schema "transactions" do
    field :transaction_type, :string
    field :amount, :decimal
    field :description, :string
    field :timestamp, :naive_datetime
    field :balance_after_transaction, :decimal

    timestamps()
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:transaction_type, :amount, :description])
    |> validate_required([:transaction_type, :amount])
    |> validate_inclusion(:transaction_type, @valid_types)
    |> validate_number(:amount, greater_than: 0)
  end

  def calculate_interest(%{balance_after_transaction: balance}) do
    if Decimal.compare(balance, 0) == :gt do
      balance
      |> Decimal.div(5)
      |> Decimal.to_float()
      |> Float.floor()
      |> Decimal.new()
    else
      Decimal.new(0)
    end
  end
end
