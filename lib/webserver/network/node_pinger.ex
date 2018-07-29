defmodule Webserver.NodePinger do
  use GenServer

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Server Callbacks

  def init(:ok) do
    Process.send_after(self(), {:full_ping}, 10000)
    {:ok, %{}}
  end

  def handle_info({:full_ping}, _state) do
    now = :os.system_time()
    # IO.puts("Now is #{now}")
    pinged_nodes = full_ping_fun()
    IO.puts("Pinged nodes #{inspect(pinged_nodes)}")
    Process.send_after(self(), {:full_ping}, 20000)
    {:noreply, %{:time_pinged => now, :pinged_nodes => pinged_nodes}}
  end

  def handle_info(msg, state) do
    IO.puts("Msg received is #{inspect(msg)}")
    {:noreply, state}
  end

  ## Private functions

  # :lasp_peer_service.members()
  def full_ping_fun() do
    IO.puts "Starting full ping"
    IO.puts "Node list is #{inspect Node.list} and I am #{inspect Node.self}"
    IO.puts "Partisan peer port is: #{inspect :partisan_config.get(:peer_port)}"
    IO.puts("#{inspect :partisan_peer_service_manager.myself}")
    IO.puts "Manager config value is #{inspect Application.get_env(:partisan, :partisan_peer_service_manager, "")}"
    IO.puts "Lasp cluster membership is: #{inspect :lasp_peer_service.members()}"
    # nodes_list = [:generic_node_1@GrispAdhoc, :generic_node_2@GrispAdhoc]
    # nodes_list = [:node@my_grisp_board_2, :node@my_grisp_board_3]
    remote_nodes_list = Application.get_env(:webserver, :remote_hosts, [])
    IO.puts "remote hosts: #{inspect remote_nodes_list}"
    # nodes_list = [:idiot@Laymer]
    for node <- remote_nodes_list, Node.connect(String.to_atom(node)) == true, do: fn node ->
      :lasp_peer_service.join(String.to_atom(node))
      IO.puts "Joined #{node}"
      node
    end.(node)
  end
end
