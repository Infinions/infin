# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :infin,
  ecto_repos: [Infin.Repo]

# Configures the endpoint
config :infin, InfinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LoWbMfM6GY8E1PRJLaqWw3vebQtl71vBKBUccoEvVPprYT7UyGqBFTkmn73SeHaa",
  render_errors: [view: InfinWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Infin.PubSub,
  live_view: [signing_salt: "ZtkrwQ6M"],
  pt_invoices_url: "localhost:3000",
  statistics_url: "localhost:5600/graphql"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
