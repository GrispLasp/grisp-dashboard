defmodule Webserver.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Webserver.NodePinger, name: Webserver.NodePinger},
      {Webserver.NodeClient, name: Webserver.NodeClient},
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
