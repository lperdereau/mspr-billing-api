defmodule MsprBillingApi.MixProject do
  use Mix.Project

  def get_version() do
    {version, _exit_code} =System.cmd("git", ["describe", "--abbrev=0", "--tag"])
    String.trim(version)
      |> String.split("-")
      |> Enum.take(2)
      |> Enum.join(".")
      |> String.replace_leading("v", "")
  end

  def project do
    [
      app: :mspr_billing_api,
      name: "Billing API",
      version: get_version(),
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [markdown_processor: ExDoc.Markdown.Earmark],
      javascript_config_path: "../version.js",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      releases: [
        app: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent, mspr_billing_api: :permanent]
        ],
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MsprBillingApi.Application, []},
      extra_applications: [:logger, :runtime_tools],
      included_applications: [:mnesia]
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
      {:phoenix, "~> 1.4.14"},
      {:phoenix_pubsub, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:open_api_spex, "~> 3.6"},
      {:cors_plug, "~> 1.5"},
      {:mock, "~> 0.3.4"},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
