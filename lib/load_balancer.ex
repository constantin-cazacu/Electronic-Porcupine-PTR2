defmodule LoadBalancer do
  @moduledoc false
  use GenServer

  def start_link(type) do
    GenServer.start_link(__MODULE__, 0, name: String.to_atom("#{type}LoadBalancer"))
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