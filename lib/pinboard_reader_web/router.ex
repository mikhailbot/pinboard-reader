defmodule PinboardReaderWeb.Router do
  use PinboardReaderWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", PinboardReaderWeb do
    pipe_through(:api)
  end
end
