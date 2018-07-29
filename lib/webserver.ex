defmodule Webserver do
  use Application
  require Logger

  def start(_type, _args) do

    # :partisan_config.set(:partisan_peer_service_manager, :partisan_hyparview_peer_service_manager)
    # :partisan_config.set(:peer_port, 9002)
    # :partisan_config.set(:peer_ip, {192,168,1,5})
    # IO.puts "#{inspect :partisan_config.get(:peer_ip)}"
    # IO.puts "peer ip #{inspect :partisan_config.get(:peer_ip)}"



    Logger.info("Started application")

    # Logger.info("port is: #{inspect  Application.get_env(:webserver, :port)}")
    # Logger.info("host is: #{inspect  Application.get_env(:webserver, :host)}")
    Logger.info("#{inspect :net_adm.names()}")
    Logger.info("#{inspect :net_adm.localhost()}")
    Logger.info("#{inspect Node.self()} ----")
    Logger.info("#{inspect Node.get_cookie()}")

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
