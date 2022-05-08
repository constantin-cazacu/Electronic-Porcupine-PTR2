defmodule Batcher do
  @moduledoc false
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def add_record(record) do
    GenServer.cast(__MODULE__, {:add, record})
  end

  def schedule_buffer() do
    Process.send_after(self(), :free, 1000)
  end

  def init(_opts) do
    schedule_batcher()
    {:ok, %{batch: [], records_per_interval: 0}}
  end

  def handle_cast({:add, record}, state) do
    record_buffer = [record | state.buffer]
    case state.records_per_interval > 200 do
      true ->
        :open_connection_and_send
        {:noreply, %{batch: [], records_per_interval: 0}}
      false ->
        {:noreply, state}
    end
    {:noreply, %{batch: record_buffer, records_per_interval: state.records_per_interval + 1}}
  end

  def handle_info(:free, state) do
    :open_connection_and_send
    schedule_buffer()
    {:noreply, state}
  end
end