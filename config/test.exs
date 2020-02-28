use Mix.Config

# Configure your database
config :mspr_billing_api, MsprBillingApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "mspr_billing_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mspr_billing_api, MsprBillingApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
