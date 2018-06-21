defmodule Webserver.NodeClient do
  use GenServer

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get_crdt() do
    GenServer.call(__MODULE__, {:get_crdt})
  end

  def get_nodes() do
    GenServer.call(__MODULE__, {:get_nodes})
  end

  def get_node(node) do
    GenServer.call(__MODULE__, {:get_node, node})
  end

  def compute() do
    GenServer.call(__MODULE__, {:compute})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:compute}, _from, state) do
    crdt_states = [
   idiot@Laymer: {:state, [240, 203, 87, 88, 147, 235, 151],
    [ok: 43, ok: 68, ok: 97, ok: 37, ok: 56, ok: 72, ok: 51],
    [
      {28, 1, 54},
      {77, 63, 34},
      {88, 100, 83},
      {80, 95, 83},
      {92, 90, 12},
      {33, 10, 8},
      {97, 15, 76}
    ]}
 ]

# nodes_map is %{last_ping_time: 1528669088051038000, nodes: [%{alive: true, avg: 14.275, counter: 5, hour_avg: [17.5, 15.75, 15.041666666666666, 14.71875, 14.275], hour_data: [17.5, 14.0, 13.625, 13.75, 12.5], name: :generic_node_1@GrispAdhoc}]}
 # Webserver.NodeClient.compute()

 nodes_states = Enum.into(crdt_states, [], fn(node) ->
   IO.puts "node is #{inspect node}"
   node_name = elem(node, 0)
   state = elem(node, 1)
   als_state = elem(state, 1)
   gyro_state = elem(state, 3)
   %{:name => node_name, :als_state => als_state, :gyro_state => gyro_state}
   # IO.puts "node name is #{inspect node_name}"
 end)


 IO.puts "nodes map is #{inspect nodes_states}"

 # for node <- nodes_state, do: fn node ->
   # IO.puts "=== node is #{inspect node}"

   # IO.puts " node is #{inspect elem(node, 0)}"
   # node
 # end.(node)

 crdt_list = [
   {:idiot@Laymer, 15.59375, 4, [11.75, 13.75, 15.625, 15.59375],
    [11.75, 15.75, 19.375, 15.5]}
 ]

 nodes_temps = Enum.into(crdt_list, [], fn {name, avg, counter, hour_avg, hour_data} ->
   # is_alive =  Enum.member?(ping_result[:pinged_nodes], name) # Check if node has been pinged, if so, mark as alive
   %{:name => name, :temps_state => %{:avg => avg, :counter => counter, :hour_avg => hour_avg, :hour_data => hour_data}}
 end)

 IO.puts "nodes temps is #{inspect nodes_temps}"

 nodes = for t <- nodes_temps, s <- nodes_states, do: fn (t,s) ->
   # IO.puts "t is #{inspect t}"
   if t[:name] == s[:name] do
     x = Map.merge(t,s)
     x
   end
 end.(t,s)



  # IO.puts "=== states crdt #{inspect nodes_state} ==="
  {:reply, nodes, state}
  end

   # Webserver.NodeClient.compute()

  def handle_call({:get_crdt}, _from, state) do
    {:ok, temps_crdt} = :lasp.query({<<"temp">>, :state_orset})
    {:ok, states_crdt} = :lasp.query({<<"states">>, :state_orset})
    temps_list = :sets.to_list(temps_crdt)
    states_list = :sets.to_list(states_crdt)
    IO.puts "=== temps crdt #{inspect temps_list} ==="
    IO.puts "=== states crdt #{inspect states_list} ==="
    {:reply, {temps_list, states_list}, state}
  end

  def handle_call({:get_nodes}, _from, state) do
    # {:ok, temps_crdt} = :lasp.query({<<"temp">>, :state_orset})
    # temps_list = :sets.to_list(temps_crdt)
    # IO.puts "=== temps crdt #{inspect temps_list} ==="
    {:reply, :ok, state}
  end

  def handle_info(msg, state) do
    IO.puts("Msg received is #{inspect(msg)}")
    {:noreply, state}
  end
end
