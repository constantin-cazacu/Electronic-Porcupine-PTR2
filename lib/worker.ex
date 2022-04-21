defmodule Worker do
  @moduledoc false
  


  use GenServer

  def start_link(index, :engagement) do
    GenServer.start_link(__MODULE__, %{}, nme: String.to_atom("EngagementWorker#{index}"))
  end

  def start_link(index, :sentiment) do
    GenServer.start_link(__MODULE__, %{}, nme: String.to_atom("SentimentWorker#{index}"))
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end