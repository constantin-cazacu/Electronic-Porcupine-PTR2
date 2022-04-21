defmodule AutoScaler do
  @moduledoc false
  


  use GenServer

  def start_link(:engagement) do
    GenServer.start_link(__MODULE__, state, name: EngagementAutoScaler)
  end

  def start_link(:sentiment) do
    GenServer.start_link(__MODULE__, state, name: SentimentAutoScaler)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end