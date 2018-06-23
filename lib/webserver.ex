defmodule Webserver do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Started application")

    case mode() do
        :computation_only ->
            Logger.info("Computation only")
        :full ->
            Logger.info("Normal")
            children = [
                {Plug.Adapters.Cowboy2, scheme: :http, plug: Webserver.Router, options: [port: port()]}
            ]

            Supervisor.start_link(children, strategy: :one_for_one)
        _ ->
            Logger.info("Unknown mode")
    end
    Webserver.Supervisor.start_link(name: Webserver.Supervisor)
  end

  def port do
    Application.get_env(:webserver, :port)
  end

  def mode do
    Application.get_env(:webserver, :mode)
  end
end
