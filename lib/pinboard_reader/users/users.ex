defmodule PinboardReader.Users do

  alias PinboardReader.Users.{Supervisor, Cache}

  def start_cache(token) do
    pid = :gproc.whereis_name({:n, :l, {:user_cache, token}})

    unless :undefined == pid do
      {:ok, pid}
    else
      Supervisor.start_user_cache(token)
    end
  end

  def get_newest_articles(token) do
    Cache.get_newest_articles(token)
  end

  def get_oldest_articles(token) do
    Cache.get_oldest_articles(token)
  end

  def get_all_articles(token) do
    Cache.get_all_articles(token)
  end
end
