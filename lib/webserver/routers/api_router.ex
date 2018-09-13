defmodule Webserver.ApiRouter do
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(:match)
  plug(:dispatch)

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
    nodes_map = generate_nodes_map(:all)
    IO.puts("nodes_map is #{inspect nodes_map}")
    body = Poison.encode!(nodes_map)
    send_resp(conn, 200, body)
  end

  get "/node/:node" do
    nodes_map =  generate_nodes_map(node)
    IO.puts("nodes_map is #{inspect nodes_map}")
    body = Poison.encode!(nodes_map)
    send_resp(conn, 200, body)
  end

  def generate_nodes_map(who) do
    crdt = Webserver.NodeClient.get_crdt(who, :state_gset)
    ping_result = Process.whereis(Webserver.NodePinger) |> :sys.get_state

    # IO.puts "crdt  #{inspect crdt}"
    # IO.puts "pinged nodes #{inspect ping_result}"

    map = %{:temp => [], :press => [], :als => [], :gyro => [], :mag => []}
    nodes = Enum.map(crdt, fn {node, data} ->
      is_alive =  Enum.member?(ping_result[:pinged_nodes],  String.to_atom(node)) # Check if node has been pinged, if so, mark as alive
      new_data = Enum.sort(data, &(hd(&1) <= hd(&2)))
      # IO.puts "new data is #{inspect new_data}"
      new_map = Enum.reduce(new_data, map , fn list, acc ->
          t = Enum.at(list,1)
          als = Enum.at(list,2)
          press = Float.round(Enum.at(list,3),2)
          temp = Float.round(Enum.at(list,4),2)
          mag = Enum.map(Enum.at(list,5), fn x -> Float.round(x,2) end)
          gyro = Enum.map(Enum.at(list,6), fn x -> Float.round(x,2) end)
          acc = Map.update!(acc, :als, fn old_list -> old_list ++ [als] end)
          acc = Map.update!(acc, :press, fn old_list -> old_list ++ [press] end)
          acc = Map.update!(acc, :temp, fn old_list -> old_list ++ [temp] end)
          acc = Map.update!(acc, :mag, fn old_list -> old_list ++ [mag] end)
          acc = Map.update!(acc, :gyro, fn old_list -> old_list ++ [gyro] end)
      end)
      %{:name => node, :alive => is_alive, :data => new_map}
    end)
    IO.puts "nodes  #{inspect nodes}"
    nodes_map = %{:nodes => nodes,:last_ping_time => ping_result[:time_pinged]}
    IO.puts("nodes_map is #{inspect nodes_map}")
    nodes_map

  end
end
