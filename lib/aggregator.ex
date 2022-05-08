defmodule Aggregator do
  @moduledoc false
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def add_engagement_score(id, engagement_score) do
    GenServer.cast(__MODULE__, {:engagement, {id, engagement_score}})
  end

  def add_sentiment_score(id, sentiment_score) do
    GenServer.cast(__MODULE__, {:sentiment, {id, sentiment_score}})
  end

  def add_tweet_info(id, tweet_data) do
    GenServer.cast(__MODULE__, {:tweet, {id, tweet_data}})
  end

  def get_records(id, records) do
    has_key = Map.has_key?(records, id)
    case has_key do
      false -> Map.put(records, id, %{})
      _ -> records
    end
  end

  def update_record(records, id, record_type, info) do
    record = Map.get(records, id)
    Map.put(record, record_type, info)
  end

  def update_record_by_id(records, key, new_record) do
    Map.update!(records, key, fn _obsolete_record -> new_record end)
  end

  def get_keys_number(record) do
    record
    |> Map.keys()
    |> Kernel.length()
  end

  def create_object(record) do
    tweet = record["tweet"]
    tweet_user = tweet["user"]
    tweet = Map.update!(tweet, "user", fn user -> user["id"] end)

    %{tweet_data: %{engagement_score: record["engagement"], sentiment_score: record["sentiment"], tweet: tweet}, user: tweet_user}
  end

  def create_record(record_type, info, id, state) do
    records = get_records(id, state.records)
    record = update_record(records, id, record_type, info)
    records = update_record_by_id(records, id, record)
    case get_keys_number(record) do
      3 ->
        object = create_object(record)
        Batcher.add_record(object)
        Map.delete(state.records, id)
      _ ->
        records
    end
  end

  def init(_opts) do
    {:ok, %{records: %{}}}
  end

  def handle_cast({:engagement, {id, engagement_score}}, state) do
    records = create_record("engagement", engagement_score, id, state)
    {:noreply, state}
  end

  def handle_cast({:sentiment, {id, sentiment_score}}, state) do
    records = create_record("sentiment", sentiment_score, id, state)
    {:noreply, state}
  end

  def handle_cast({:tweet, {id, tweet_data}}, state) do
    records = create_record("tweet", tweet_data, id, state)
    {:noreply, state}
  end

end