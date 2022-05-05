defmodule PoolSupervisor do
  @moduledoc false
  use DynamicSupervisor
  require Logger

  def start_link(type) do
    supervisor = DynamicSupervisor.start_link(__MODULE__, %{}, name: ("#{type}PoolSupervisor"))
    Logger.info(IO.ANSI.format([:yellow, "starting Pool Supervisor"]))
    PoolSupervisor.start_worker(4)
    supervisor
  end

  def init(_) do
    supervisor = DynamicSupervisor.init(max_restarts: 100, max_children: 1000, strategy: :one_for_one)
    #    PoolSupervisor.start_worker(4)
    supervisor
  end

end
