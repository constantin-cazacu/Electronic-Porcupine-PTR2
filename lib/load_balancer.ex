defmodule LoadBalancer do
  @moduledoc false
  use GenServer

  def start_link(:engagement) do
    GenServer.start_link(__MODULE__, 0, name: EngagementLoadBalancer)
  end

  def start_link(:sentiment) do
    GenServer.start_link(__MODULE__, 0, name: SentimentLoadBalancer)
  end

  def receive_tweet(id, tweet) do
    GenServer.cast(__MODULE__, {:receive_tweet, {id, tweet}})
  end

  def init(index) do
    {:ok, index}
  end

  def handle_cast({:receive_tweet, {id, tweet}}, state) do

    {:noreply, state}
  end
end