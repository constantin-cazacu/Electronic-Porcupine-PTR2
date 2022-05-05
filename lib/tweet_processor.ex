defmodule TweetProcessor do
  @moduledoc """
  Documentation for `TweetProcessor`.
  """
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info(IO.ANSI.format([:yellow, "starting Application"]))
    url1 = "http://localhost:4000/tweets/1"
    url2 = "http://localhost:4000/tweets/2"

    children = [
      %{
        id: StreamReader1,
        start: {StreamReader, :start_link, [url1]}
      },
      %{
        id: StreamReader2,
        start: {StreamReader, :start_link, [url2]}
      },
      %{
        id: Router,
        start: {Router, :start_link, []}
      },
#      %{
#        id: EngagementTopSupervisor,
#        start: {TopSupervisor, :start_link, ["Engagement"]}
#      },
#      %{
#        id: SentimentTopSupervisor,
#        start: {TopSupervisor, :start_link, ["Sentiment"]}
#      },
#      %{
#        id: RetweetTopSupervisor,
#        start: {TopSupervisor, :start_link, ["Retweet"]}
#      },
#      %{
#        id: Aggregator,
#        start: {Aggregator, :start_link, []}
#      },
#      %{
#        id: Batcher,
#        start: {Batcher, :start_link, []}
#      },
    ]

    opts = [strategy: :one_for_one, max_restarts: 100, name: __MODULE__]

    Supervisor.start_link(children, opts)
  end
end
