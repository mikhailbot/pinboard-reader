use Mix.Config

config :pinboard_reader, PinboardReaderWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")
