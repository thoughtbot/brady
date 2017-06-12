defmodule Brady.Mixfile do
  use Mix.Project

  def project do
    [
      app: :brady,
      build_embedded: Mix.env == :prod,
      deps: deps(),
      description: "Template helpers for Phoenix applications",
      elixir: "~> 1.3",
      package: package(),
      start_permanent: Mix.env == :prod,
      version: "0.0.7",
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:floki, "~> 0.13"},
      {:phoenix, "~> 1.3.0-dev"},
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/thoughtbot/brady"},
      maintainers: ["Ashley Ellis", "Jason Draper"],
    ]
  end
end
