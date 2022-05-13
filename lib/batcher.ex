defmodule Batcher do
  @moduledoc false
  use GenServer
  require Logger

  @batch_size 99
  @timer_length 1000

  def start_link() do
    Logger.info("Starting Batcher", anis_color: :yellow_background)
    {:ok, mongo_pid} = Mongo.start_link(url: "mongodb://localhost:27017/TweetDataStream")
    timer_ref = schedule_batcher()
    GenServer.start_link(__MODULE__, %{batch: [], records_per_interval: 0, mongo_pid: mongo_pid, timer_ref: timer_ref}, name: __MODULE__)
  end

  def add_record(record) do
    GenServer.cast(__MODULE__, {:add, record})
  end

  def schedule_batcher() do
    timer_ref = Process.send_after(self(), :free, @timer_length)
  end

  def send_batch(records, mongo_pid) do
    batch_size = Kernel.length(records)
    #    batch_no = System.unique_integer([:positive, :monotonic])
    Logger.info("[Batcher] Sending batch. Batch Size: #{batch_size}", ansi_color: :light_magenta)
    Mongo.insert_many(mongo_pid, "tweets", get_tweets(records))
    Mongo.insert_many(mongo_pid, "users", get_users(records))
  end

  def get_tweets(records) do
    Enum.map(records, fn object -> object.tweet_data end)
  end

  def get_users(records) do
    Enum.map(records, fn object -> object.user end)
  end

  def init(state) do
#    schedule_batcher()
    {:ok, state}
  end

  def handle_cast({:add, record}, state) do
    record_buffer = [record | state.batch]
    new_records_per_interval = state.records_per_interval + 1
    #    {:noreply, %{batch: record_buffer, records_per_interval: state.records_per_interval + 1, mongo_pid: state.mongo_pid}}
    case state.records_per_interval >= @batch_size do
      true ->
        send_batch(record_buffer, state.mongo_pid)
        Process.cancel_timer(state.timer_ref)
        timer_ref = schedule_batcher()
        {:noreply, %{batch: [], records_per_interval: 0, mongo_pid: state.mongo_pid, timer_ref: timer_ref}}
      false ->
#        Logger.info("[Batcher] added to record buffer", ansi_color: :light_blue)
        {:noreply, %{batch: record_buffer, records_per_interval: new_records_per_interval, mongo_pid: state.mongo_pid, timer_ref: state.timer_ref}}
    end
  end

  def handle_info(:free, state) do
    if Kernel.length(state.batch) == 0 do
#      Process.cancel_timer(state.timer_ref)
      timer_ref = schedule_batcher()
      {:noreply, %{batch: state.batch, records_per_interval: state.records_per_interval, mongo_pid: state.mongo_pid, timer_ref: timer_ref}}
    else
      send_batch(state.batch, state.mongo_pid)
#      Process.cancel_timer(state.timer_ref)
      timer_ref = schedule_batcher()
      {:noreply, %{batch: [], records_per_interval: 0, mongo_pid: state.mongo_pid, timer_ref: timer_ref}}
    end
  end

end
