# TweetProcessor

Stream Processing application using the actor model. Consumes a docker container of tweets
distributing the tweets to 3 pools of workers (Sentiment Analysis Pool, Engagement Analysis
Pool and Retweet Analysis Pool) each pool is scaled according to the streamed tweets per second,
each worker is parsing the received tweet and does its job:
* Engagement Score workers calculate the engagement ratio of the tweet (#favorites + #retweets) / #followers;
* Sentiment Score worker calculate the value of the tweet text by comparing each word against an 
emotional score map;
* Retweet Score workers extract each original tweet from a retweet and send it back to the
Router in order to be distributed the other pools.  

The results are aggregated back together and sent to a database into 2 collections (users
and tweets) through a mechanic called adaptive batching which opens a database connection
every 1 second (adjustable) or when the batch max size is reached.  

Additional features:
* Resumable / pausable transmission between the Aggregator and the Batcher (in case of DB
unavailability);
* Metrics “endpoint” to monitor the stats of the Sink or DB controller (ingested messages, 
average execution time, 75’th, 90’th, 95’th percentile execution time);

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tweet_processor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tweet_processor, "~> 0.1.0"}
  ]
end
```
The image containing the SSE streams is available at alexburlacu/rtp-server:faf18x

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tweet_processor>.

