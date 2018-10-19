defmodule PinboardReaderWeb.UserView do
  use PinboardReaderWeb, :view
  alias PinboardReaderWeb.UserView

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, UserView, "article.json")}
  end

  def render("article.json", %{user: user}) do
    %{
      href: user["href"],
      description: user["description"],
      extended: user["extended"],
      meta: user["meta"],
      hash: user["hash"],
      time: user["time"],
      shared: user["shared"],
      toread: user["toread"],
      tags: user["tags"]
    }
  end
end
