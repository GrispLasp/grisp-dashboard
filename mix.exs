defmodule Webserver.MixProject do
  use Mix.Project

  def project do
    [
      app: :webserver,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
                plt_add_deps: :transitive,
                flags: [:unmatched_returns,:error_handling,:race_conditions, :no_opaque],
                paths: ["_build/dev/lib/webserver/ebin"],
                dialyzer: [ignore_warnings: "dialyzer.ignore-warnings"]
              ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Webserver, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.4.0"},
      {:lasp, "~> 0.8.2"},
      {:poison, "~> 3.1"},
      {:plug, "~> 1.5.1"},
      {:cors_plug, "~> 1.5"},
      {:exsamples, "~> 0.1.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end
end
