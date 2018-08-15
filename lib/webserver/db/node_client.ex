defmodule Webserver.NodeClient do
  use GenServer

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get_crdt(name, type) do
    GenServer.call(__MODULE__, {:get_crdt, {name, type}})
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

   # Webserver.NodeClient.compute()

  def handle_call({:get_crdt, {name, type}}, _from, state) do
    :lasp.query({<<"node@my_grisp_board_2">>, :state_gset})
    crdt = case name do
      :all ->
        nodes_list = Enum.map(1..2, fn number ->
          Enum.join(["node@my_grisp_board", Integer.to_string(number)], "_")
         end)
         Enum.reduce(nodes_list, %{}, fn node, acc ->
           {:ok, crdt_list} = :lasp.query({node, type}) 
           # IO.puts "#{inspect crdt_list}"
           crdt_data = :sets.to_list(crdt_list)
           Map.put(acc, node, crdt_data)
         end)
      _ ->
        {:ok, crdt_list} = :lasp.query({name, type})
        crdt_data = :sets.to_list(crdt_list)
        %{name => crdt_data}
    end

    # IO.puts "=== crdt is #{inspect crdt} ==="
    {:reply, crdt, state}
  end

  def handle_call({:get_nodes}, _from, state) do

    {:reply, :ok, state}
  end

  def handle_info(msg, state) do
    IO.puts("Msg received is #{inspect(msg)}")
    {:noreply, state}
  end
end
