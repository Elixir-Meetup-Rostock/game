defmodule Game.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GameWeb.Telemetry,
      Game.Repo,
      {DNSCluster, query: Application.get_env(:game, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Game.PubSub},
      GameWeb.Presence,
      # Start the State server
      {Game.State, name: Game.State},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Game.Finch},
      # Start a worker by calling: Game.Worker.start_link(arg)
      # {Game.Worker, arg},
      # Start to serve requests, typically the last entry
      GameWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Game.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
