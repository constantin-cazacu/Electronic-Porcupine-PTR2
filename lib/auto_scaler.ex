defmodule AutoScaler do
  @moduledoc false
  


  use GenServer

  def start_link(type) do
    GenServer.start_link(__MODULE__, type, name: String.to_atom("#{type}AutoScaler"))
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end