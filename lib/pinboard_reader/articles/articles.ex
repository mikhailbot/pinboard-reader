defmodule PinboardReader.Articles do
  @moduledoc """
  The primary Context for working with articles saved in Pinboard
  """
  alias PinboardReader.Articles.Broker

  def process(articles) do
    articles
    |> Enum.map(fn article -> perform({:fetch, article}) end)
  end

  defp perform({action, args} = params) do
    case :sbroker.ask(Broker, {self(), params}) do
      {:go, ref, worker, _, _queue_time} ->
        monitor = Process.monitor(worker)

        receive do
          {^ref, result} ->
            Process.demonitor(monitor, [:flush])
            result

          {:DOWN, ^monitor, _, _, reason} ->
            exit({reason, {__MODULE__, action, args}})
        end

      {:drop, _time} ->
        {:error, :overload}
    end
  end

  def get(url) do
    with {:ok, %HTTPoison.Response{} = response} <- HTTPoison.get(url, [], follow_redirect: true) do
      try do
        article =
          response.body
          |> parse()

        {:ok, %{href: url, article: article}}
      rescue
        _ -> {:error, %{reason: "error processing article", href: url}}
      end
    else
      {:error, %HTTPoison.Error{} = error} ->
        {:error, %{reason: error, href: url}}
    end
  end

  defp parse(html) do
    html
    |> Readability.article()
    |> Readability.readable_html()
  end
end
