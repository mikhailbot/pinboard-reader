defmodule PinboardReaderWeb.UserController do
  use PinboardReaderWeb, :controller

  alias PinboardReader.Users

  def index(conn, %{"list" => list, "token" => token}) do
    Users.start_cache(token)

    case list do
      "newest" -> Users.get_newest_articles(token) |> render_list(conn)
      "oldest" -> Users.get_oldest_articles(token) |> render_list(conn)
      _ -> Users.get_all_articles(token) |> render_list(conn)
    end
  end

  defp render_list({:ok, articles}, conn) do
    render(conn, "index.json", articles: articles)
  end
end
