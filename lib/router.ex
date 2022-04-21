defmodule Router do
  @moduledoc false
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, nme: __MODULE__)
  end

  def receive_tweet(tweet) do
    id = UUID.uuid1()
    GenServer.cast(__MODULE__, {:engagement, {id, tweet}})
    GenServer.cast(__MODULE__, {:sentiment, {id, tweet}})
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_cast({:engagement, {id, tweet}}, state) do
    EngagementLoadBalancer.receive_tweet(id, tweet)
  end

  def handle_cast({:sentiment, {id, tweet}}, state) do
    SentimentLoadBalancer.receive_tweet(id, tweet)
  end

end