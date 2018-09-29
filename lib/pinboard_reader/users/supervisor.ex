defmodule PinboardReader.Users.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :user_supervisor)
  end

  def start_user_cache(username) do
    Supervisor.start_child(:user_supervisor, [username])
  end

  def init(_) do
    children = [
      worker(PinboardReader.Users.Cache, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
