import Config

if System.get_env("PHX_SERVER") do
  config :family_bank, FamilyBankWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :family_bank, FamilyBank.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :family_bank, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :family_bank, FamilyBankWeb.Endpoint,
    url: [host: host, scheme: "https", port: 443],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  config :family_bank, FamilyBankWeb.Endpoint,
    check_origin: ["//#{host}"],
    force_ssl: [rewrite_on: [:x_forwarded_proto]]
end
