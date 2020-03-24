defmodule MsprBillingApiWeb.JsonHelpers do
  @moduledoc """
  Provides json-related functions.
  """

  @moduledoc since: "v0.0.1"

  @doc """
  Allow you to render json data
  ## Parameters

    - conn: Plug.Conn that represents the connection to anwser the client.
    - status: Integer that represents the HTTP status code return to the client.
    - data: Map return to the client

  ## Exemples
      alias MsprBillingApiWeb.JsonHelpers
      def show(conn) do
        JsonHelpers.pretty_json(conn, 200, %{msg: "ok"})
      end
  """
  @doc since: "v0.0.1"
  def pretty_json(conn, status, data) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json; charset=utf-8")
    |> Plug.Conn.send_resp(status, Poison.encode!(data, pretty: true))
  end
end
