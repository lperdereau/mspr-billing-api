defmodule MsprBillingApiWeb.VatController do
  use MsprBillingApiWeb, :controller
  alias MsprBillingApiWeb.{JsonHelpers, Gettext}

  @notFoundId "%{ressource} not found"

  def show(conn, %{"product" => product}) do
    url = System.get_env("API_URL")
    # "#{url}/api/product/#{product}"
    case HTTPoison.get("#{url}/status/#{product}") do
      {:ok, %{status_code: 200}} ->
        JsonHelpers.pretty_json(conn, 200, %{status: 200})

      {:ok, %{status_code: 404}} ->
        JsonHelpers.pretty_json(conn, 404,
        %{
          msg: Gettext.gettext(@notFoundId, ressource: "product")
        })

      {:error, %{reason: _reason}} ->
        # do something with an error
        JsonHelpers.pretty_json(conn, 500, %{message: "Error"})
      _ ->
        JsonHelpers.pretty_json(conn, 500, %{message: "Error"})
    end
  end
end
