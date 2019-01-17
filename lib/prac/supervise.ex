defmodule Prac.Supervise do

  use Supervisor

    def start_link(opts) do
      Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
    {DynamicSupervisor, name: Prac.BucketSupervisor, strategy: :one_for_one},
    {Prac.Registry, name: Prac.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end