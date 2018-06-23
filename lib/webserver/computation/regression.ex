defmodule Webserver.Regression do
  use GenServer

  import Numerix.LinearRegression

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Server Callbacks

  def init(:ok) do
    Process.send_after(self(), {:fit}, 1000)
    {:ok, %{}}
  end

  def handle_info({:fit}, _state) do
    now = :os.system_time()
    IO.puts("Now is #{now}")
    {intercept, slope} = fit([1.3, 2.1, 3.7, 4.2], [2.2, 5.8, 10.2, 11.8])
    IO.puts("Intercept = #{intercept} Slope = #{slope}")
    {:noreply, %{:time => now, :intercept => intercept, :slope => slope}}
  end

  def handle_info(msg, state) do
    IO.puts("Msg received is #{inspect(msg)}")
    {:noreply, state}
  end

  ## Private functions

end
