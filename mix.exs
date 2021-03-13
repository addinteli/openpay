defmodule Openpay.MixProject do
  @moduledoc false
  use Mix.Project

  @organization "addinteli"

  def project do
    [
      app: :openpay,
      version: "0.3.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      description: "This client allows interact with openpay.mx APIs.",
      package: package(),
      # exdocs
      name: "ADM Base",
      source_url: "https://github.com/paridin/openpay",
      homepage_url: "https://paridin.com",
      docs: [
        # The main page in the docs
        main: "Openpay",
        # logo: "logo.png",
        extras: ["README.md"]
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.json": :test,
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test
      ]
    ]
  end

  defp package do
    [
      organization: @organization,
      licenses: ["Apache-2.0"],
      links: %{}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Openpay.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:money, "~> 1.7"},
      {:httpoison, "~> 1.5"},
      {:timex, "~> 3.6"},
      {:plug_cowboy, "~> 2.3"},
      {:jason, "~> 1.2"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:exvcr, "~> 0.10", only: [:dev, :test]},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
