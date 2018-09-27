defmodule PinboardReaderWeb.Router do
  use PinboardReaderWeb, :router
  use Terraform, terraformer: PinboardReaderWeb.Terraformers.Pinboard

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", PinboardReaderWeb do
    pipe_through(:api)

    post("/articles", ArticleController, :index)
  end
end
