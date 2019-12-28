defmodule YamlEncoder.MixProject do
  use Mix.Project

  def project do
    [
      app: :yaml_encoder,
      version: "0.1.0",
      elixir: ">= 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:yaml_elixir, "~> 2.4", only: :dev}
    ]
  end
end
