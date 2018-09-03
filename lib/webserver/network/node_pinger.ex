defmodule Webserver.NodePinger do
  use GenServer

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Server Callbacks

  def init(:ok) do
    Process.send_after(self(), {:full_ping}, 20000)
    {:ok, %{}}
  end

  def handle_info({:full_ping}, _state) do
    now = :os.system_time()
    IO.puts("Now is #{now}")
    pinged_nodes = full_ping()
    IO.puts("Pinged nodes #{inspect(pinged_nodes)}")
    Process.send_after(self(), {:full_ping}, 5000)
    {:noreply, %{:time_pinged => now, :pinged_nodes => pinged_nodes}}
  end

  def handle_info(msg, state) do
    IO.puts("Msg received is #{inspect(msg)}")
    {:noreply, state}
  end

  ## Private functions

  # :lasp_peer_service.members()

  def full_ping() do
    IO.puts "Starting full ping"
    # name = "node@my_grisp_board_1"
    # :lasp.update({name, :state_gset}, {:add, "hello"}, self())
    # {:ok, x}  = :lasp.query({name, :state_gset})
    # y = :sets.to_list(x)
    # IO.puts "#{inspect y}"
    # IO.puts "#{inspect x}"
    nodes_list = Enum.map(1..3, fn number ->
      String.to_atom(Enum.join(["node@my_grisp_board", Integer.to_string(number)], "_"))
     end)
    # IO.puts "#{inspect nodes_list}"
    for node <- nodes_list, :net_adm.ping(node) == :pong, do: fn node ->
      :lasp_peer_service.join(node)
      IO.puts "joined #{node}"
      node
    end.(node)
  end
end
