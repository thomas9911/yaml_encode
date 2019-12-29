defmodule YamlEncode.MixProject do
  use Mix.Project

  def project do
    [
      app: :yaml_encode,
      version: "0.2.0",
      elixir: ">= 1.6.0",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.html": :test],
      deps: deps(),
      source_url: "https://github.com/thomas9911/yaml_encode",
      package: package(),
      name: "YamlEncode",
      docs: [
        main: "YamlEncode",
        extra_section: []
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:yaml_elixir, "~> 2.4", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp package do
    [
      description: "Package for encoding Maps to Yaml",
      licenses: ["Unlicense"],
      links: %{"Github" => "https://github.com/thomas9911/yaml_encode"}
    ]
  end
end
