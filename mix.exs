defmodule ConfigUtils.MixProject do
  use Mix.Project

  @version "0.2.0"
  @github "https://github.com/rwillians/elixir-config-utils"

  @description """
  A set of opinionated  utility functions to be used in configuration files.
  """

  def project do
    [
      app: :config_utils,
      version: @version,
      description: @description,
      source_url: @github,
      homepage_url: @github,
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [debug_info: Mix.env() == :dev],
      package: package(),
      docs: [
        main: "Config.Utils",
        source_ref: "v#{@version}",
        source_url: @github,
        canonical: "http://hexdocs.pm/config_utils",
        extras: ["LICENSE"]
      ],
      deps: deps()
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs .formatter.exs README.md LICENSE),
      maintainers: ["Rafael Willians"],
      contributors: ["Rafael Willians"],
      licenses: ["MIT"],
      links: %{
        GitHub: @github,
        Changelog: "#{@github}/releases"
      }
    ]
  end

  def deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
