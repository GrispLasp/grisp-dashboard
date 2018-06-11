defmodule Webserver.ApiRouter do
  use Plug.Router

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug :match
  plug :dispatch


  # Root path
  get "/" do
    send_resp(conn, 200, "Health check OK")
  end


  get "/alive-nodes" do
    node_pinger_pid = Process.whereis(Webserver.NodePinger)
    pinged_nodes = :sys.get_state(node_pinger_pid)
    body = Poison.encode!(pinged_nodes)
    send_resp(conn, 200, body)
  end

  get "/nodes" do
    {crdt_temps,crdt_states} = Webserver.NodeClient.get_crdt()
    ping_result = Process.whereis(Webserver.NodePinger) |> :sys.get_state
    IO.puts "pinged nodes #{inspect ping_result}"
    nodes_temps = Enum.into(crdt_temps, [], fn {name, avg, counter, hour_avg, hour_data} ->
      is_alive =  Enum.member?(ping_result[:pinged_nodes], name) # Check if node has been pinged, if so, mark as alive
      %{:name => name, :alive => is_alive, :temps_state => %{:avg => avg, :counter => counter, :hour_avg => hour_avg, :hour_data => hour_data}}
    end)

    nodes_states = Enum.into(crdt_states, [], fn(node) ->
      # IO.puts "node is #{inspect node}"
      node_name = elem(node, 0)
      state = elem(node, 1)
      als_state = elem(state, 1)
      gyro_state_tuples = elem(state, 3)
      gyro_state = Enum.into(gyro_state_tuples, [], fn gyro -> Tuple.to_list(gyro) end)
      %{:name => node_name, :als_state => als_state, :gyro_state => gyro_state}
      # IO.puts "node name is #{inspect node_name}"
    end)

    nodes = for t <- nodes_temps, s <- nodes_states, do: fn (t,s) ->
      # IO.puts "t is #{inspect t}"
      if t[:name] == s[:name] do
        Map.merge(t,s)
      end
    end.(t,s)

    nodes_map = %{:nodes => nodes,:last_ping_time => ping_result[:time_pinged]}
    IO.puts("nodes_map is #{inspect nodes_map}")
    body = Poison.encode!(nodes_map)
    send_resp(conn, 200, body)
  end

  get "/testnodes" do
    # TODO : poll edge to retrive measurements for each node

    # crdt_list = Webserver.NodeClient.get_crdt()
    # ping_result = Process.whereis(Webserver.NodePinger) |> :sys.get_state
    # IO.puts "pinged nodes #{inspect ping_result}"
    # nodes_map = Enum.into(crdt_list, [], fn {name, avg, counter, hour_avg, hour_data} ->
    #   is_alive =  Enum.member?(ping_result[:pinged_nodes], name) # Check if node has been pinged, if so, mark as alive
    #   %{:name => name, :avg => avg, :counter => counter, :hour_avg => hour_avg, :hour_data => hour_data, :alive => is_alive}
    # end)
    #
    # nodes_map = %{:nodes => nodes_map, :last_ping_time => ping_result[:time_pinged]}
    # IO.puts("nodes_map is #{inspect nodes_map}")
    # body = Poison.encode!(nodes_map)
    send_resp(conn, 200, :empty)
  end


  get "/node/:node" do
    crdt_list = Webserver.NodeClient.get_crdt()
    node_map = for {name,avg,counter} <- crdt_list, name == String.to_atom(node), do: %{:name => name, :avg => avg, :counter => counter}
    body = Poison.encode!(node_map)
    send_resp(conn, 200, body)
  end

end
