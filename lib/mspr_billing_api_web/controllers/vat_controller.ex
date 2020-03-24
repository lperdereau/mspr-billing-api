defmodule MsprBillingApiWeb.VatController do
  use MsprBillingApiWeb, :controller
  alias MsprBillingApiWeb.{JsonHelpers, Gettext}
  alias MsprBillingApi.Billing.{Vat, Product}

  @notFoundId "%{ressource} not found with this id"

  def show(conn, %{"product_id" => product_id}) do
    url = System.get_env("CART_API_URL")
    case HTTPoison.get("#{url}/products/#{product_id}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        JsonHelpers.pretty_json(conn, 200,
          Product.get_vat(Poison.decode!(body, as: %Product{}))
        )

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

  def show_vat(conn, %{"type" => type}) do
    tab = Vat.get_vat_by_type(type)
    case length(tab) do
      1 ->
        JsonHelpers.pretty_json(conn, 200, List.first(tab))
      0 ->
        JsonHelpers.pretty_json(conn, 404, %{
          msg: Gettext.gettext(@notFoundId, ressource: "vat")
        })
      _ ->
        JsonHelpers.pretty_json(conn, 500, %{message: "Error"})
    end
  end

  def show_vats(conn, _params) do
    tab = Vat.get_vats()
    case length(tab) do
      0 ->
        JsonHelpers.pretty_json(conn, 404, %{
          msg: Gettext.gettext(@notFoundId, ressource: "vat")
        })
      _ ->
        JsonHelpers.pretty_json(conn, 200, tab)
    end
  end
end
