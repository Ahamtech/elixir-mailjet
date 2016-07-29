defmodule Mailjet.Mixfile do
  use Mix.Project

  def project do
    [app: :mailjet,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
    package: [
       contributors: ["Anwesh Reddy", "Mahesh Reddy", "John Ankanna"],
       licenses: ["Artistic"],
       links: %{github: "https://github.com/Ahamtech/elixir-mailjet"}
     ],
     description: """
     Elixir Mailjet Client
     """]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :inets, :ssl]]
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
    []
  end
end
