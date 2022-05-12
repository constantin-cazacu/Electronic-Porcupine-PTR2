defmodule EngagementAnalysis.TopSupervisor do
  use Supervisor
  require Logger

  def start_link() do
    IO.inspect("Starting Engagement Top Supervisor", ansi_color: :yellow_background)
    Supervisor.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    children = [
      %{
        id: EngagementLoadBalancer,
        start: {EngagementAnalysis.LoadBalancer, :start_link, []}
      },
      %{
        id: EngagementAutoScaler,
        start: {EngagementAnalysis.AutoScaler, :start_link, []}
      },
      %{
        id: EngagementPoolSupervisor,
        start: {EngagementAnalysis.PoolSupervisor, :start_link, []}
      },
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 100)
  end

end
