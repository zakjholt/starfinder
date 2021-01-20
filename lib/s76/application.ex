defmodule S76.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      S76.Repo,
      # Start the Telemetry supervisor
      S76Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: S76.PubSub},
      # Start the Endpoint (http/https)
      S76Web.Endpoint,
      # Start a worker by calling: S76.Worker.start_link(arg)
      # {S76.Worker, arg}

      # Handles the scheduled jobs
      S76.Scheduled
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: S76.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    S76Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
