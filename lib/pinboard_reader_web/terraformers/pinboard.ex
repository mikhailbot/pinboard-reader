defmodule PinboardReaderWeb.Terraformers.Pinboard do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get _ do
    %{method: "GET", request_path: request_path, params: params} = conn

    token = get_req_header(conn, "authorization")

    res =
      HTTPoison.get!(
        "https://api.pinboard.in#{request_path}",
        [
          {"Authorization", token}
        ],
        params: Map.to_list(params)
      ) |> IO.inspect

    send_response({:ok, conn, res})
  end

  defp send_response({:ok, conn, %{status_code: status_code, body: body}}) do
    send_resp(conn, status_code, body)
  end
end
