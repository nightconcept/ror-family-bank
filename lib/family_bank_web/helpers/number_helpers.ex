defmodule FamilyBankWeb.NumberHelpers do
  def format_currency(%Decimal{} = value) do
    value
    |> Decimal.to_float()
    |> format_currency()
  end

  def format_currency(value) when is_float(value) do
    "$#{:erlang.float_to_binary(value, decimals: 2)}"
  end

  def format_currency(value) when is_integer(value) do
    "$#{value}.00"
  end
end
