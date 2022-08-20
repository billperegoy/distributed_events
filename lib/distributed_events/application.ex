defmodule DistributedEvents.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DistributedEvents.Repo,
      # Start the Telemetry supervisor
      DistributedEventsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DistributedEvents.PubSub},
      # Start the Endpoint (http/https)
      DistributedEventsWeb.Endpoint,
      # Start a worker by calling: DistributedEvents.Worker.start_link(arg)
      # {DistributedEvents.Worker, arg}
      DistributedEvents.Finance.InvoiceServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DistributedEvents.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DistributedEventsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
