# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :s76,
  ecto_repos: [S76.Repo]

config :s76, S76.Scheduled,
  jobs: [
    # Runs daily at midnight:
    {"@daily", {S76.Scheduled, :backfill_stargazers, []}}
  ]

# Configures the endpoint
config :s76, S76Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FrygYz+I1q5smjZiaJS70EksJRsvqti9T4E1KyHAuWsuRRuu/Xsuq4TAkPnIhR6N",
  render_errors: [view: S76Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: S76.PubSub,
  live_view: [signing_salt: "MP9zpcUi"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
