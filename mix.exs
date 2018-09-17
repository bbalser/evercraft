defmodule Evercraft.MixProject do
  use Mix.Project

  def project do
    [
      app: :evercraft,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Evercraft.Application, []}
    ]
  end

  defp deps do
    [
      {:checkov, "~> 0.4.0", only: :test},
      {:exactor, "~> 2.2"},
      {:dialyxir, "~> 0.5.1", only: :dev, runtime: false}
    ]
  end
end
