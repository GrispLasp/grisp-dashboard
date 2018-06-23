defmodule Webserver.Regression do
  use GenServer

  import Numerix.LinearRegression

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Server Callbacks

  def init(:ok) do
    Process.send_after(self(), {:fit}, 30000)
    # Process.send_after(self(), {:fit}, 1000)
    {:ok, %{}}
  end

  def handle_info({:fit}, _state) do
    nodes = get_states()
    regressions = Enum.into(nodes, [], fn(n) ->
      {intercept, slope} = fit(n[:xs], n[:ys])
      IO.puts("Intercept = #{inspect intercept} Slope = #{inspect slope}")
      %{:intercept => intercept, :slope => slope}
    end)
    Process.send_after(self(), {:fit}, 30000)
    {:noreply, %{:regressions => regressions}}
  end

  def handle_info(msg, state) do
    IO.puts("Msg received is #{inspect(msg)}")
    {:noreply, state}
  end

  ## Private functions

  def get_states() do
    {:ok, states_crdt} = :lasp.query({<<"states">>, :state_orset})
    states_list = :sets.to_list(states_crdt)
    # states_list = [node@my_grisp_board_10: {:state, [{129, {{2018, 6, 23}, {14, 24, 5}}}, {123, {{2018, 6, 23}, {14, 24, 38}}}, {124, {{2018, 6, 23}, {14, 25, 1}}}, {122, {{2018,6, 23}, {14, 25, 24}}}, {121, {{2018, 6, 23}, {14, 25, 47}}}, {122, {{2018, 6, 23}, {14, 26, 10}}}, {140, {{2018, 6, 23}, {14, 26, 33}}}, {137, {{2018, 6, 23}, {14, 26, 56}}}, {126, {{2018, 6, 23}, {14, 27, 19}}}, {131, {{2018, 6, 23}, {14, 27, 42}}}, {132, {{2018, 6, 23}, {14, 28, 5}}}, {154, {{2018, 6, 23}, {14, 28, 28}}}, {124, {{2018, 6, 23}, {14,28, 51}}}]}]
    IO.puts "=== states crdt #{inspect states_list} ==="
    nodes = for n <- states_list, do: fn(n) ->
      measurements = elem(elem(n, 1), 1)
      List.foldl(measurements, %{:xs => [], :ys => []}, fn(row, acc) ->
        alight = acc[:xs] ++ [elem(row, 0)]
        # FIXME : datetime_to_gregorian_seconds returns a 11-digit integer
        # as date and time representation. Hence the calculus performed by Numerix
        # is subject to overflow and results can become incorrect
        # time = acc[:ys] ++ [:calendar.datetime_to_gregorian_seconds(elem(row, 1))]
        time = acc[:ys] ++ [datetime_to_minute_of_day(elem(row, 1))]
        acc2 = Map.replace!(acc, :xs, alight)
        acc3 = Map.replace!(acc2, :ys, time)
        acc3
       end)
     end.(n)
     IO.puts "=== Predictors and Criterions arrays : #{inspect nodes} ==="
     nodes
  end

  def datetime_to_minute_of_day(datetime) do
    case datetime do
       {_date, {h, mi, _s}} when is_integer(h) when is_integer(mi) ->
         minute_of_day = h*60 + mi
         minute_of_day
       _ ->
        0
    end
  end

end
# [node@my_grisp_board_10: {:state, [{129, {{2018, 6, 23}, {14, 24, 5}}}, {123, {{2018, 6, 23}, {14, 24, 38}}}, {124, {{2018, 6, 23}, {14, 25, 1}}}, {122, {{2018,6, 23}, {14, 25, 24}}}, {121, {{2018, 6, 23}, {14, 25, 47}}}, {122, {{2018, 6, 23}, {14, 26, 10}}}, {140, {{2018, 6, 23}, {14, 26, 33}}}, {137, {{2018, 6, 23}, {14, 26, 56}}}, {126, {{2018, 6, 23}, {14, 27, 19}}}, {131, {{2018, 6, 23}, {14, 27, 42}}}, {132, {{2018, 6, 23}, {14, 28, 5}}}, {154, {{2018, 6, 23}, {14, 28, 28}}}, {124, {{2018, 6, 23}, {14,28, 51}}}]}]
