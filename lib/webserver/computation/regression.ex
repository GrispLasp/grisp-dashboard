defmodule Webserver.Regression do
  use GenServer

  import Numerix.LinearRegression

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get_regression() do
    GenServer.call(__MODULE__, {:fit})
  end

  def get_transformed_als_state(als_state) do
    GenServer.call(__MODULE__, {:get_transformed_als_state, als_state})
  end

  ## Server Callbacks

  def init(:ok) do
    # Process.send_after(self(), {:fit}, 5000)
    # Process.send_after(self(), {:test}, 1000)
    {:ok, %{}}
  end

  def handle_call({:get_transformed_als_state, als_state}, _from, state) do


      # n = als_state
      # IO.puts "node name is #{inspect node_name}"


      IO.puts("als_state = #{inspect als_state} ")
      measurements_state = als_state
      measurements = List.foldl(measurements_state, %{:xs => [], :ys => []}, fn(row, acc) ->
        alight = acc[:ys] ++ [elem(row, 0)]
        # FIXME : datetime_to_gregorian_seconds returns a 11-digit integer
        # as date and time representation. Hence the calculus performed by Numerix
        # is subject to overflow and results can become incorrect
        # time = acc[:ys] ++ [:calendar.datetime_to_gregorian_seconds(elem(row, 1))]
        time = acc[:xs] ++ [datetime_to_minute_of_day(elem(row, 1))]
        acc2 = Map.replace!(acc, :ys, alight)
        acc3 = Map.replace!(acc2, :xs, time)
        acc3
       end)
       numbers = 0..length(measurements[:xs])
       numbers_list = Enum.to_list(numbers)
       predictions = Enum.map(numbers_list, fn minute ->
         predict(minute, measurements[:xs], measurements[:ys])
       end)

       als_new_state = %{:data => measurements, :predictions => predictions}

       IO.puts("als_new_state = #{inspect als_new_state} ")
       {:reply, als_new_state, state}

     # {:noreply, %{:regressions => nodes_als_states}}
  end

  def handle_call({:fit}, _from, state) do
  # def handle_info({:fit}, _state) do
    numbers = 0..100
    numbers_list = Enum.to_list(numbers)
    data = get_states()
    n = List.first(data)
    {intercept, slope} = fit(n[:ys], n[:xs])
    IO.puts("Intercept = #{inspect intercept} Slope = #{inspect slope}")
    prediction = predict(868, n[:xs], n[:ys])
    IO.puts("Prediction = #{inspect prediction}")
    %{:intercept => intercept, :slope => slope}
    predictions = Enum.map(numbers_list, fn minute ->
      predict(minute, n[:xs], n[:ys])
    end)
    # Process.send_after(self(), {:fit}, 5000)

    IO.puts("predictions = #{inspect(predictions)}")
    node_map = %{:data => data, :predictions => predictions}
    {:reply, node_map, state}
    # {:noreply, %{:regressions => regressions}}
  end

  def handle_info(msg, state) do
    IO.puts("Msg received is #{inspect(msg)}")
    {:noreply, state}
  end

  ## Private functions

  def get_states() do
    {:ok, states_crdt} = :lasp.query({<<"states">>, :state_orset})
    # states_list = :sets.to_list(states_crdt)
    states_list = [node@my_grisp_board_10: {:state, [{129, {{2018, 6, 23}, {14, 24, 0}}}, {123, {{2018, 6, 23}, {14, 25, 0}}}, {124, {{2018, 6, 23}, {14, 26, 0}}}, {122, {{2018,6, 23}, {14, 27, 0}}}, {121, {{2018, 6, 23}, {14, 28, 0}}}, {122, {{2018, 6, 23}, {14, 29, 0}}}, {140, {{2018, 6, 23}, {14, 30, 0}}}, {137, {{2018, 6, 23}, {14, 31, 0}}}, {126, {{2018, 6, 23}, {14, 32, 0}}}, {131, {{2018, 6, 23}, {14, 33, 0}}}, {132, {{2018, 6, 23}, {14, 34, 0}}}, {154, {{2018, 6, 23}, {14, 35, 0}}}, {124, {{2018, 6, 23}, {14, 36, 0}}}]}]
    IO.puts "=== states crdt #{inspect states_list} ==="
    nodes = for n <- states_list, do: fn(n) ->
      measurements = elem(elem(n, 1), 1)
      List.foldl(measurements, %{:xs => [], :ys => []}, fn(row, acc) ->
        alight = acc[:ys] ++ [elem(row, 0)]
        # FIXME : datetime_to_gregorian_seconds returns a 11-digit integer
        # as date and time representation. Hence the calculus performed by Numerix
        # is subject to overflow and results can become incorrect
        # time = acc[:ys] ++ [:calendar.datetime_to_gregorian_seconds(elem(row, 1))]
        time = acc[:xs] ++ [datetime_to_minute_of_day(elem(row, 1))]
        acc2 = Map.replace!(acc, :ys, alight)
        acc3 = Map.replace!(acc2, :xs, time)
        acc3
       end)
     end.(n)
     IO.puts "=== Predictors and Responses arrays : #{inspect nodes} ==="
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
