defmodule PinboardReader.Users.Cache do
  use GenServer

  # API

  def start_link(username) do
    GenServer.start_link(__MODULE__, %{username: username}, name: via_tuple(username))
  end

  defp via_tuple(username) do
    {:via, :gproc, {:n, :l, {:user_cache, username}}}
  end

  def get_newest_articles(username) do
    GenServer.call(via_tuple(username), :get_newest_articles)
  end

  # SERVER

  def init(initial_state) do
    state = %{
      username: initial_state.username,
      all: [],
      newest: [],
      oldest: []
    }

    {:ok, state}
  end

  def handle_call(:get_newest_articles, _from, state) do
    {:reply, {:ok, state.oldest}, state}
  end
end
