defmodule Router do
  @moduledoc false
  use GenServer
  require Logger

  def start_link() do
    Logger.info(">>> Starting Router <<<", ansi_color: :yellow_background)
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def receive_tweet(tweet) do
    id = System.unique_integer([:positive, :monotonic])
    GenServer.cast(__MODULE__, {id, tweet})
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_cast({id, tweet}, state) do
    EngagementAnalysis.LoadBalancer.get_tweets( id, tweet)
    EngagementAnalysis.AutoScaler.receive_notification()
    RetweetExtracting.LoadBalancer.get_tweets(id, tweet)
    RetweetExtracting.AutoScaler.receive_notification()
    SentimentAnalysis.LoadBalancer.get_tweets(id, tweet)
    SentimentAnalysis.AutoScaler.receive_notification()
    {:noreply, state}
  end

end