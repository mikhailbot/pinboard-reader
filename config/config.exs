# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :pinboard_reader, PinboardReaderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "S5aWKFlC6KCk5ILWsxRrq0OU0kudd8/8KIZAjCsRq5WZYWi3koP2nPPpHXsnxDo7",
  render_errors: [view: PinboardReaderWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PinboardReader.PubSub, adapter: Phoenix.PubSub.PG2]

# CORS
config :cors_plug,
  origin: ["*"],
  max_age: 86400,
  methods: ["GET", "POST"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :sasl, sasl_error_logger: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
