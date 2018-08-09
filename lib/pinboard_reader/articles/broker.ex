defmodule PinboardReader.Articles.Broker do
  @behaviour :sbroker

  def start_link() do
    start_link(timeout: 10000)
  end

  def start_link(opts) do
    :sbroker.start_link({:local, __MODULE__}, __MODULE__, opts, [])
  end

  def init(opts) do
    # See `DBConnection.Sojourn.Broker`.

    # Make the "left" side of the broker a FIFO queue that drops the request after the timeout is reached.
    client_queue =
      {:sbroker_timeout_queue,
       %{
         out: :out,
         timeout: opts[:timeout],
         drop: :drop,
         min: 0,
         max: 128
       }}

    # Make the "right" side of the broker a FIFO queue that has no timeout.
    worker_queue =
      {:sbroker_drop_queue,
       %{
         out: :out_r,
         drop: :drop,
         timeout: :infinity
       }}

    {:ok, {client_queue, worker_queue, []}}
  end
end
