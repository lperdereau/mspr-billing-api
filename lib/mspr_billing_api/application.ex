defmodule MsprBillingApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias MsprBillingApi.Billing.Vat

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      MsprBillingApiWeb.Endpoint
      # Starts a worker by calling: MsprBillingApi.Worker.start_link(arg)
      # {MsprBillingApi.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MsprBillingApi.Supervisor]
    :mnesia.create_schema([node()])
    :mnesia.start()
    Vat.create_table()
    Vat.insert_vat()
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MsprBillingApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
