defmodule TopSupervisor.Supervisor do
  @moduledoc false
  use Supervisor
  require Logger

  def start_link(:engagement) do
    Supervisor.start_link(__MODULE__, %{}, name: EngagementTopSupervisor)
  end

  def start_link(:sentiment) do
    Supervisor.start_link(__MODULE__, %{}, name: EngagementTopSupervisor)
  end

  def init(_arg) do
    children = [
      %{
        id: LoadBalancer,
        start: {LoadBalancer, :start_link, []}
      },
    ]

    supervise(children, strategy: :one_for_one)
  end
end