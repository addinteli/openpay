defmodule Openpay.Router do
  @moduledoc """
  A plug responsible for logging request info, parsing request body's as JSON
  matching routes, and dispatching responses.
  """

  use Plug.Router

  # required plugs
  plug(Plug.RequestId)
  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  get "/" do
    send_resp(conn, 200, "Openpay Authorization")
  end

  # post "/authz" do
    # result = Jason.encode!(conn.body_params)
    # send_resp(conn, 200, result)
    # Openpay.Authz.Verify()
  # end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
