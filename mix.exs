defmodule PinboardReader.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pinboard_reader,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PinboardReader.Application, []},
      extra_applications: [:logger, :runtime_tools, :sbroker, :httpoison, :readability]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:httpoison, "~> 1.3.1", override: true},
      {:readability, "~> 0.9"},
      {:sbroker, "~> 1.0-beta"},
      {:terraform, "~> 1.0.1"},
      {:cors_plug, "~> 1.5"},
    ]
  end
end
