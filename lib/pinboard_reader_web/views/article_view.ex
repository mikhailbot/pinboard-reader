defmodule PinboardReaderWeb.ArticleView do
  use PinboardReaderWeb, :view
  alias PinboardReaderWeb.ArticleView

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, ArticleView, "article.json")}
  end

  def render("article.json", %{article: {:ok, article}}) do
    %{
      href: article.href,
      readable_html: article.article
    }
  end

  def render("article.json", %{article: {:error, error}}) do
    %{
      href: error.href,
      readable_html: ""
    }
  end
end
