defmodule Infin.MixProject do
  use Mix.Project

  def project do
    [
      app: :infin,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Infin.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:bcrypt_elixir, "~> 2.0"},
      {:phoenix, "~> 1.5.5"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.14.6"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:phx_gen_auth, "~> 0.5", only: [:dev], runtime: false},
      {:ex_machina, "~> 2.4"},
      {:httpoison, "~> 1.7"},
      {:scrivener_ecto, "~> 2.0"},
      {:arc_ecto, "~> 0.11.3"},
      {:sweet_xml, "~> 0.6.6"},
      {:html_entities, "~> 0.5.1"},
      {:neuron, "~> 5.0.0"},
      {:timex, "~> 3.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.bootstrap": ["ecto.migrate", "run priv/repo/banks.exs"],
      "ecto.setup": [
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "run priv/repo/banks.exs",
        "run priv/repo/seeds.exs"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "docker.up": [
        "cmd docker login -u=machadovilaca -p=bf9ebaf2843c4b79bb60daeb1c961cbf repo.treescale.com",
        "cmd docker-compose up -d",
        "setup"
      ],
      "docker.down": ["cmd docker-compose down"],
      "podman.up": [
        "cmd podman login -u=machadovilaca -p=bf9ebaf2843c4b79bb60daeb1c961cbf repo.treescale.com",
        "cmd podman-compose up -d",
        "setup"
      ],
      "podman.down": ["cmd podman-compose down"]
    ]
  end
end
