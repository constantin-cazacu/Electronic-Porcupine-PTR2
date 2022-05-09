defmodule TopSupervisor do
  @moduledoc false
  use Supervisor
  require Logger

  def start_link(type) do
    IO.inspect(">>> Starting #{type} Top Supervisor <<<")
    Supervisor.start_link(__MODULE__, type, name: String.to_atom("#{type}TopSupervisor"))
  end

  def init(type) do
    children = [
      %{
        id: LoadBalancer,
        start: {LoadBalancer, :start_link, [type]}
      },
      %{
        id: AutoScaler,
        start: {AutoScaler, :start_link, [type]}
      },
      %{
        id: PoolSupervisor,
        start: {PoolSupervisor, :start_link, [type]}
      },
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end