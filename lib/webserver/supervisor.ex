defmodule Webserver.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    # children = [
    #   {Webserver.NodePinger, name: Webserver.NodePinger},
    #   {Webserver.NodeClient, name: Webserver.NodeClient},
    # ]
    #
    # Supervisor.init(children, strategy: :one_for_one)
    children = case mode() do
        :computation_only ->
            [
                {Webserver.Regression, name: Webserver.Regression}
            ]
        :full ->
            [
                {Webserver.NodePinger, name: Webserver.NodePinger},
                {Webserver.NodeClient, name: Webserver.NodeClient},
                {Webserver.Regression, name: Webserver.Regression}
            ]
        _ ->
            []
    end

    Supervisor.init(children, strategy: :one_for_one)
  end

  def mode do
    Application.get_env(:webserver, :mode)
  end

end
