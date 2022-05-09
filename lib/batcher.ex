defmodule Batcher do
  @moduledoc false
  use GenServer
  require Logger

  def start_link() do
    IO.inspect(">>> Starting Batcher <<<")
    {:ok, mongo_pid} = Mongo.start_link(url: "mongodb://mongoM1:27017,mongoM2:27017,mongoM3:27017/tweeter?replicaSet=rs0")
    GenServer.start_link(__MODULE__, %{batch: [], records_per_interval: 0, mongo_pid: mongo_pid}, name: __MODULE__)
  end

  def add_record(record) do
    GenServer.cast(__MODULE__, {:add, record})
  end

  def schedule_batcher() do
    Process.send_after(self(), :free, 1000)
  end

  def send_batch(records) do
    GenServer.cast(__MODULE__, {:send, records})
  end

  def get_tweets(records) do
    Enum.map(records, fn object -> object.tweet_data end)
  end

  def get_users(records) do
    Enum.map(records, fn object -> object.user end)
  end

  def init(state) do
    schedule_batcher()
    {:ok, state}
  end

  def handle_cast({:add, record}, state) do
    record_buffer = [record | state.batch]
    case state.records_per_interval > 200 do
      true ->
        send_batch(record_buffer)
        schedule_batcher()
        {:noreply, %{batch: [], records_per_interval: 0}}
      false ->
        IO.inspect("[Batcher] added to record buffer")
        {:noreply, %{batch: record_buffer, records_per_interval: state.records_per_interval + 1, mongo_pid: state.mongo_pid}}
    end
  end

  def handle_info(:free, state) do
    send_batch(state.batch)
    schedule_batcher()
    {:noreply, %{batch: [], records_per_interval: 0, mongo_pid: state.mongo_pid}}
  end

  def handle_cast({:send, records}, state) do
    IO.inspect("[Batcher] sending batch")
    Mongo.insert_many(state.mongo_pid, "tweets", get_tweets(records))
    Mongo.insert_many(state.mongo_pid, "users", get_users(records))
    {:noreply, state}
  end
end