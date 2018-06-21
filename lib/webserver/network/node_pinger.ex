defmodule Webserver.NodePinger do
  use GenServer

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Server Callbacks

  def init(:ok) do
    Process.send_after(self(), {:full_ping}, 1000)
    {:ok, %{}}
  end

  def handle_info({:full_ping}, _state) do
    now = :os.system_time()
    IO.puts("Now is #{now}")
    pinged_nodes = full_ping_fun()
    IO.puts("Pinged nodes #{inspect(pinged_nodes)}")
    Process.send_after(self(), {:full_ping}, 10000)
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
    # nodes_list = [:generic_node_1@GrispAdhoc, :generic_node_2@GrispAdhoc]
    # nodes_list = [:node@my_grisp_board_10, :node@my_grisp_board_11]
    nodes_list = [:idiot@Laymer]
    for node <- nodes_list, :net_adm.ping(node) == :pong, do: fn node ->
      :lasp_peer_service.join(node)
      IO.puts "joined #{node}"
      node
    end.(node)
  end

    for node <- nodes_list,
        :net_adm.ping(node) == :pong,
        do:
          (fn node ->
             :lasp_peer_service.join(node)
             IO.puts("joined #{node}")
             node
           end).(node)
  end
end
