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

  get "/regression" do
    regressions = Webserver.Regression.get_regression()
    node = %{:name => "test", :regressions => regressions}
    body = Poison.encode!(node)
    send_resp(conn, 200, body)
  end

  get "/nodes-test" do
    nodes_temps = [%{alive: true, name: :generic_node_2@GrispAdhoc, temps_state: %{avg: 15.174999999999997, counter: 40, hour_avg: [16.6, 12.600000000000001, 12.866666666666667, 14.8, 15.6, 14.7, 14.485714285714284, 13.975, 14.688888888888888, 15.659999999999998, 15.618181818181817, 15.683333333333332, 15.83076923076923, 16.17142857142857, 15.653333333333332, 16.162499999999998, 16.082352941176467, 16.35555555555555, 16.031578947368416, 15.949999999999996, 15.980952380952376, 15.663636363636359, 15.539130434782605, 15.374999999999996, 15.199999999999996, 15.230769230769226, 15.140740740740737, 15.035714285714281, 14.972413793103446, 14.926666666666664, 15.129032258064512, 14.924999999999997, 15.072727272727269, 15.129411764705878, 15.148571428571426, 15.138888888888888, 14.902702702702703, 14.942105263157893, 15.015384615384614, 15.174999999999997], hour_data: [16.6, 8.6, 13.4, 20.6, 18.8, 10.2, 13.2, 10.4, 20.4, 24.4, 15.2, 16.4, 17.6, 20.6, 8.4, 23.8, 14.8, 21.0, 10.2, 14.4, 16.6, 9.0, 12.8, 11.6, 11.0, 16.0, 12.8, 12.2, 13.2, 13.6, 21.2, 8.6, 19.8, 17.0, 15.8, 14.8, 6.4, 16.4, 17.8, 21.4]}}, %{alive: true, name: :generic_node_1@GrispAdhoc, temps_state: %{avg: 14.879999999999995, counter: 40, hour_avg: [14.8, 18.1, 15.066666666666668, 14.25, 13.760000000000002, 13.466666666666669, 13.314285714285717, 13.275000000000002, 13.57777777777778, 13.360000000000003, 13.12727272727273, 13.41666666666667, 13.523076923076925, 13.585714285714287, 13.813333333333334, 13.9, 13.882352941176471, 13.799999999999999, 13.71578947368421, 13.779999999999998, 13.97142857142857, 14.245454545454546, 14.243478260869567, 14.375, 14.376000000000001, 14.438461538461539, 14.481481481481481, 14.471428571428572, 14.779310344827586, 14.473333333333333, 14.541935483870967, 14.599999999999998, 14.58181818181818, 14.658823529411762, 14.605714285714285, 14.505555555555555, 14.556756756756755, 14.757894736842102, 14.77435897435897, 14.879999999999995], hour_data: [14.8, 21.4, 9.0, 11.8, 11.8, 12.0, 12.4, 13.0, 16.0, 11.4, 10.8, 16.6, 14.8, 14.4, 17.0, 15.2, 13.6, 12.4, 12.2, 15.0, 17.8, 20.0, 14.2, 17.4, 14.4, 16.0, 15.6, 14.2, 23.4, 5.6, 16.6, 16.4, 14.0, 17.2, 12.8, 11.0, 16.4, 22.2, 15.4, 19.0]}}]


    crdt_states = [{
      :generic_node_1@GrispAdhoc,
     {:state, [{129, {{2018, 6, 23}, {0, 0, 0}}}, {123, {{2018, 6, 23}, {0, 1, 0}}}, {124, {{2018, 6, 23}, {0, 2, 0}}}, {122, {{2018,6, 23}, {0, 3, 0}}}, {121, {{2018, 6, 23}, {0, 4, 0}}}, {122, {{2018, 6, 23}, {0, 5, 0}}}, {140, {{2018, 6, 23}, {0, 6, 0}}}, {137, {{2018, 6, 23}, {0, 7, 0}}}, {126, {{2018, 6, 23}, {0, 8, 0}}}, {131, {{2018, 6, 23}, {0, 9, 0}}}, {132, {{2018, 6, 23}, {0, 10, 0}}}, {154, {{2018, 6, 23}, {0, 11, 0}}}, {124, {{2018, 6, 23}, {0, 12, 0}}}]}},
     {:generic_node_2@GrispAdhoc,
     {:state, [{105, {{2018, 6, 23}, {0, 0, 0}}}, {112, {{2018, 6, 23}, {0, 1, 0}}}, {114, {{2018, 6, 23}, {0, 2, 0}}}, {116, {{2018,6, 23}, {0, 3, 0}}}, {113, {{2018, 6, 23}, {0, 4, 0}}}, {107, {{2018, 6, 23}, {0, 5, 0}}}, {110, {{2018, 6, 23}, {0, 6, 0}}}, {111, {{2018, 6, 23}, {0, 7, 0}}}, {112, {{2018, 6, 23}, {0, 8, 0}}}, {131, {{2018, 6, 23}, {0, 9, 0}}}, {132, {{2018, 6, 23}, {0, 10, 0}}}, {154, {{2018, 6, 23}, {0, 11, 0}}}, {124, {{2018, 6, 23}, {0, 12, 0}}}]}}
   ]

    nodes_states = Enum.into(crdt_states, [], fn(node) ->
      node_name = elem(node, 0)
      state = elem(node, 1)
      als_state = elem(state, 1)
      new_als_state = Webserver.Regression.get_transformed_als_state(als_state)
      # IO.puts "new_als_state is #{inspect new_als_state}"
      %{:name => node_name, :als_state => new_als_state}
      # IO.puts "node name is #{inspect node_name}"
    end)

    # IO.puts "nodes_states #{inspect nodes_states}"
    # IO.puts "nodes_temps #{inspect nodes_temps}"


    nodes = for t <- nodes_temps, s <- nodes_states, do: fn (t,s) ->
      # IO.puts "t is #{inspect t}"
      # IO.puts "s is #{inspect s}"

      if t[:name] == s[:name] do
        Map.merge(t,s)
      end
    end.(t,s)

    nodes_no_nils= Enum.filter(nodes, & !is_nil(&1))

    IO.puts "nodes #{inspect nodes_no_nils}"

    nodes_map = %{:nodes => nodes_no_nils,:last_ping_time => 1531523580761880000}
    # IO.puts("nodes_map is #{inspect nodes_map}")
    body = Poison.encode!(nodes_map)
    send_resp(conn, 200, body)
  end

  get "/nodes" do
    {crdt_temps,crdt_states} = Webserver.NodeClient.get_crdt()
    ping_result = Process.whereis(Webserver.NodePinger) |> :sys.get_state
      # IO.puts "crdt_temps  #{inspect crdt_temps}"
    IO.puts "pinged nodes #{inspect ping_result}"
    nodes_temps = Enum.into(crdt_temps, [], fn {name, avg, counter, hour_avg, hour_data} ->
      is_alive =  Enum.member?(ping_result[:pinged_nodes], name) # Check if node has been pinged, if so, mark as alive
      %{:name => name, :alive => is_alive, :temps_state => %{:avg => avg, :counter => counter, :hour_avg => hour_avg, :hour_data => hour_data}}
    end)
      # IO.puts "nodes_temps  #{inspect nodes_temps}"

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
      # IO.puts "nodes_states  #{inspect nodes_states}"

    if length(nodes_states) == 0 do
      nodes = nodes_temps
    else
      nodes = for t <- nodes_temps, s <- nodes_states, do: fn (t,s) ->
        # IO.puts "t is #{inspect t}"
        if t[:name] == s[:name] do
          Map.merge(s,t)
        end
      end.(t,s)
    end

      # IO.puts "nodes  #{inspect nodes}"

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

    node_map =
      for {name, avg, counter} <- crdt_list,
          name == String.to_atom(node),
          do: %{:name => name, :avg => avg, :counter => counter}

    body = Poison.encode!(node_map)
    send_resp(conn, 200, body)
  end
end
