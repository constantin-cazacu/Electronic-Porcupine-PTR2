defmodule PoolSupervisor do
  @moduledoc false
  use DynamicSupervisor
  require Logger

  def start_link(:engagement) do
    supervisor = DynamicSupervisor.start_link(__MODULE__, %{}, name: EngagementPoolSupervisor)
    Logger.info(IO.ANSI.format([:yellow, "starting Pool Supervisor"]))
    PoolSupervisor.start_worker(4)
    supervisor
  end

  def start_link(:sentiment) do
    supervisor = DynamicSupervisor.start_link(__MODULE__, %{}, name: SentimentPoolSupervisor)
    Logger.info(IO.ANSI.format([:yellow, "starting Pool Supervisor"]))
    PoolSupervisor.start_worker(4)
    supervisor
  end


end
