defmodule FamilyBank.Repo do
  use Ecto.Repo,
    otp_app: :family_bank,
    adapter: Ecto.Adapters.Postgres
end
