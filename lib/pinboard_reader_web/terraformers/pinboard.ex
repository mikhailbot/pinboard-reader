defmodule PinboardReaderWeb.Terraformers.Pinboard do
  use Plug.Router

  plug(Plug.Logger, log: :debug)

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
      )

    send_response({:ok, conn, res})
  end

  defp send_response({:ok, conn, %{headers: headers, status_code: status_code, body: body}}) do
    conn = %{conn | resp_headers: headers}
    send_resp(conn, status_code, body)
  end
end
