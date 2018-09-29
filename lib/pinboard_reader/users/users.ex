defmodule PinboardReader.Users do

  alias PinboardReader.Users.{Supervisor, Cache}

  def start_cache(username) do
    pid = :gproc.whereis_name({:n, :l, {:user_cache, username}})

    unless :undefined == pid do
      {:ok, pid}
    else
      Supervisor.start_user_cache(username)
    end
  end
end
