defmodule Polylens.MixProject do
  use Mix.Project

  def project do
    [
      app: :polylens,
      version: "0.1.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: Mix.compilers ++ [:protocol_ex],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp extra_applications(:dev), do: extra_applications(:test)
  defp extra_applications(:test), do: [:stream_data | extra_applications(123)]
  defp extra_applications(_), do: [:logger, :yamerl]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/lib"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
#      {:protocol_ex, git: "https://github.com/OvermindDL1/protocol_ex", branch: "master"},
      {:protocol_ex, "~> 0.4"},
      {:dbg, "~> 1.0", only: [:dev, :test]},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:stream_data, "~> 0.4", only: [:dev, :test]},
    ]
  end
end
