defmodule TweetProcessor.MixProject do
  use Mix.Project

  def project do
    [
      app: :tweet_processor,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:eventsource_ex, "~> 1.1.0"},
      {:unpack, "~> 0.1.7"},
      {:poison, "~> 5.0"},
      {:ex_doc, "~> 0.28.0"},
      {:elixir_uuid, "~> 1.2"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end