defmodule Router do
  @moduledoc false
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, nme: __MODULE__)
  end

  def receive_tweet(tweet) do
    id = System.unique_integer([:positive, :monotonic])
    GenServer.cast(__MODULE__, {id, tweet})
#    IO.inspect(id)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_cast({id, tweet}, state) do
    EngagementLoadBalancer.receive_tweet(id, tweet)
    SentimentLoadBalancer.receive_tweet(id, tweet)
    RetweetLoadBalancer.receive_tweet(id, tweet)
    {:ok, tweet_data} = Poison.decode(tweet)
    Aggregator.add_tweet_info(id, tweet_data)
    {:noreply, state}
  end

end