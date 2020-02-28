# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mspr_billing_api,
  ecto_repos: [MsprBillingApi.Repo]

# Configures the endpoint
config :mspr_billing_api, MsprBillingApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+05DEW24CHcCrUkdRqSDTPmbudlAETe3T+HKgYjdeqGABBRoy6fHCqhDZn1tiXE+",
  render_errors: [view: MsprBillingApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: MsprBillingApi.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "g4dKMwuv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
