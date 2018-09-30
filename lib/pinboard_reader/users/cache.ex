defmodule PinboardReader.Users.Cache do
  use GenServer

  # API

  def start_link(token) do
    GenServer.start_link(__MODULE__, %{token: token}, name: via_tuple(token))
  end

  defp via_tuple(token) do
    {:via, :gproc, {:n, :l, {:user_cache, token}}}
  end

  def get_all_articles(token) do
    GenServer.call(via_tuple(token), :get_all_articles)
  end

  def get_newest_articles(token) do
    GenServer.call(via_tuple(token), :get_newest_articles)
  end

  def get_oldest_articles(token) do
    GenServer.call(via_tuple(token), :get_oldest_articles)
  end

  # SERVER

  def init(initial_state) do
    state = %{
      token: initial_state.token,
      date: "",
      last_checked: "",
      all: [],
      newest: [],
      oldest: []
    }

    {:ok, state}
  end

  def handle_call(:get_all_articles, _from, state) do
    state =
      state
      |> update_cache

    {:reply, {:ok, state.all}, state}
  end

  def handle_call(:get_newest_articles, _from, state) do
    state =
      state
      |> update_cache

    {:reply, {:ok, state.newest}, state}
  end

  def handle_call(:get_oldest_articles, _from, state) do
    state =
      state
      |> update_cache

    {:reply, {:ok, state.oldest}, state}
  end

  defp update_cache(%{date: date, last_checked: last_checked} = state) do
    cond do
      is_bitstring(last_checked) ->
        # No data, fetching data for first time

        state
        |> update_timestamps
        |> fetch_data
        |> populate_lists

      DateTime.compare(date, last_checked) != :lt ->
        # There's been changes since we last checked, so getting new data

        state
        |> update_timestamps
        |> fetch_data
        |> populate_lists

      true ->
        # We've checked more recently than the latest changes, no new data available
        state
    end
  end

  defp fetch_data(state) do
    with {:ok, %HTTPoison.Response{} = response} <-
           HTTPoison.get(
             "https://api.pinboard.in/v1/posts/all?format=json&meta=1&toread=yes&results=1000",
             [{"Authorization", "Bearer #{state.token}"}]
           ) do
      %{state | all: Poison.decode!(response.body)}
    else
      {:error, %HTTPoison.Error{} = error} ->
        IO.inspect(error)
        state
    end
  end

  defp update_timestamps(state) do
    with {:ok, %HTTPoison.Response{} = response} <-
           HTTPoison.get(
             "https://api.pinboard.in/v1/posts/update?format=json",
             [{"Authorization", "Bearer #{state.token}"}]
           ) do
      {:ok, date, 0} =
        response.body
        |> Poison.decode!()
        |> Map.get("update_time")
        |> DateTime.from_iso8601()

      %{state | date: date, last_checked: DateTime.utc_now()}
    end
  end

  defp populate_lists(state) do
    %{state | newest: Enum.slice(state.all, 0..10), oldest: Enum.slice(state.all, -10..-1)}
  end
end
