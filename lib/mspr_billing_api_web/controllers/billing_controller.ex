defmodule MsprBillingApiWeb.BillingController do
  use MsprBillingApiWeb, :controller
  alias MsprBillingApiWeb.JsonHelpers
  alias MsprBillingApi.Billing.Cart

  def show(conn, %{"user_id" => user_id}) do
    url = System.get_env("CART_API_URL")

    case HTTPoison.get("#{url}/carts/user/#{user_id}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = Poison.decode!(body, as: %Cart{})
        JsonHelpers.pretty_json(conn, 200, %{cart_vat: Cart.get_vat(response)})
    end
  end
end
