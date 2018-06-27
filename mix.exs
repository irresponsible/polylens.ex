defmodule Polylens.MixProject do
  use Mix.Project

  def project do
    [
      app: :polylens,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: Mix.compilers ++ [:protocol_ex],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:protocol_ex, "~> 0.3.0"},
    ]
  end
end
