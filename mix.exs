defmodule PhoenixTemplateHelper.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_template_helper,
     version: "0.0.1",
     elixir: "~> 1.2",
     description: "Template helpers for Phoenix applications",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:phoenix, "~> 1.1.4"},
    ]
  end

  defp package do
    [
    files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
    maintainers: ["Ashley Ellis"],
    licenses: ["MIT"],
    links: %{"Github" => "https://github.com/thoughtbot/phoenix_template_helper"}]
  end
end
