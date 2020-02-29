defmodule MsprBillingApiWeb.JsonHelpers do
  @moduledoc """
  Provides json-related functions.
  """

  @moduledoc since: "v0.0.1"

  @doc """
  Allow you to render json data
  """
  @doc since: "v0.0.1"
  def pretty_json(conn, status, data) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json; charset=utf-8")
    |> Plug.Conn.send_resp(status, Poison.encode!(data, pretty: true))
  end
end
