defmodule Webserver.Router do
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  # plug(CORSPlug, origin: "*")
  plug(:match)
  plug(:dispatch)

  # Root path
  get "/" do
    send_resp(conn, 200, "Website health check OK")
  end

  forward("/api", to: Webserver.ApiRouter)
end
