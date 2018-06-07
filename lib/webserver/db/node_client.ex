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

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:get_crdt}, _from, state) do
    {:ok, temps_crdt} = :lasp.query({<<"temp">>, :state_orset})
    temps_list = :sets.to_list(temps_crdt)
    IO.puts "=== temps crdt #{inspect temps_list} ==="
    {:reply, temps_list, state}
  end

  def handle_call({:get_nodes}, _from, state) do

    # {:ok, temps_crdt} = :lasp.query({<<"temp">>, :state_orset})
    # temps_list = :sets.to_list(temps_crdt)
    # IO.puts "=== temps crdt #{inspect temps_list} ==="
    {:reply, :ok, state}
  end


  def handle_info(msg, state) do
    IO.puts "Msg received is #{inspect msg}"
    {:noreply, state}
  end

end
