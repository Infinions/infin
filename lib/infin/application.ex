defmodule Infin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Infin.Repo,
      # Start the Telemetry supervisor
      InfinWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Infin.PubSub},
      # Start the Endpoint (http/https)
      InfinWeb.Endpoint
      # Start a worker by calling: Infin.Worker.start_link(arg)
      # {Infin.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Infin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InfinWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
