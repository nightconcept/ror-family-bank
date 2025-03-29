defmodule FamilyBank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FamilyBankWeb.Telemetry,
      FamilyBank.Repo,
      {DNSCluster, query: Application.get_env(:family_bank, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FamilyBank.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FamilyBank.Finch},
      # Start a worker by calling: FamilyBank.Worker.start_link(arg)
      # {FamilyBank.Worker, arg},
      # Start to serve requests, typically the last entry
      FamilyBankWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FamilyBank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FamilyBankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
