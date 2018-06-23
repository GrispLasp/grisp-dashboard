defmodule Webserver do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Started application")

    children = [
      {Plug.Adapters.Cowboy2, scheme: :http, plug: Webserver.Router, options: [port: port()]}
    ]


    Webserver.Supervisor.start_link(name: Webserver.Supervisor)
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def port do
    Application.get_env(:webserver, :port)
  end
end
