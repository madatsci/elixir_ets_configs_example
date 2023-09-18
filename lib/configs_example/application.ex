defmodule ConfigsExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ConfigsExampleWeb.Telemetry,
      # Start the Ecto repository
      ConfigsExample.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ConfigsExample.PubSub},
      # Start the Endpoint (http/https)
      ConfigsExampleWeb.Endpoint,
      # Start a worker by calling: ConfigsExample.Worker.start_link(arg)
      # {ConfigsExample.Worker, arg},
      # Starting config system
      ConfigsExample.ConfigSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConfigsExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ConfigsExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
