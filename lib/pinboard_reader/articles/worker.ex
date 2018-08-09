defmodule PinboardReader.Articles.Worker do
  use GenServer

  alias PinboardReader.Articles
  alias PinboardReader.Articles.Broker

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    state =
      ask(%{
        tag: make_ref()
      })

    {:ok, state}
  end

  def handle_info({tag, {:go, ref, {pid, {:fetch, params}}, _, _}}, %{tag: tag} = s) do
    send(pid, {ref, process_article(params)})
    {:noreply, ask(s)}
  end

  # When sbroker has found a match, it'll send us `{tag, {:go, ref, req, _, _}}`.
  defp ask(%{tag: tag} = s) do
    {:await, ^tag, _} = :sbroker.async_ask_r(Broker, self(), {self(), tag})
    s
  end

  defp process_article(params) do
    case Articles.get(params) do
      {:ok, article} -> {:ok, article}
      {:error, %HTTPoison.Error{} = error} -> {:error, error}
      _ -> {:error, %{reason: "error processing article"}}
    end
  end
end
