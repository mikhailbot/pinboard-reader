defmodule PinboardReaderWeb.ArticleController do
  use PinboardReaderWeb, :controller

  def index(conn, %{ "articles" => articles }) do
    processed_articles = PinboardReader.Articles.process(articles)

    render(conn, "index.json", articles: processed_articles)
  end
end
