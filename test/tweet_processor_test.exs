defmodule TweetProcessorTest do
  use ExUnit.Case
  doctest TweetProcessor

  test "greets the world" do
    assert TweetProcessor.hello() == :world
  end
end
