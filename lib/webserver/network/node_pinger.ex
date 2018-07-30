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
    IO.puts("Me: #{inspect :partisan_peer_service_manager.myself}")
    IO.puts "Lasp cluster membership is: #{inspect :lasp_peer_service.members()}"
    remote_nodes_list = Application.get_env(:webserver, :remote_hosts, [])
    IO.puts "Remote hosts: #{inspect remote_nodes_list}"
    for remote_node <- remote_nodes_list, Node.connect(String.to_atom(remote_node)) == true, do: fn remote_node ->
      IO.puts "Trying to join remote node #{inspect remote_node}"
      remote_node_partisan_myself = :rpc.call(String.to_atom(remote_node), :partisan_hyparview_peer_service_manager, :myself, [])
      IO.puts "Remote node #{inspect remote_node_partisan_myself}"
      remote_listen_addrs = remote_node_partisan_myself[:listen_addrs]
      new_listen_addrs =  %{hd(remote_listen_addrs) | ip: get_remote_ip(String.to_atom(remote_node))}
      new_remote = %{remote_node_partisan_myself | listen_addrs: [new_listen_addrs]}
      IO.puts "New remote node settings #{inspect new_remote}"
      :lasp_peer_service.join(new_remote)
      IO.puts "Joined #{remote_node}"
      remote_node
    end.(remote_node)
  end


  def get_remote_ip(remote_name) do
    remote_nodes = %{
      :'server1@ec2-18-185-18-147.eu-central-1.compute.amazonaws.com' => {18,185,18,147},
      :'server2@ec2-18-206-71-67.compute-1.amazonaws.com' => {18,206,71,67}
    }
    remote_nodes[remote_name]

  end
end
