defmodule MsprBillingApiWeb.BillingController do
  use MsprBillingApiWeb, :controller
  alias MsprBillingApiWeb.{JsonHelpers}
  alias MsprBillingApi.Billing.{Cart, Product}

  def show(conn, %{"user_id" => user_id}) do
    url = System.get_env("CART_API_URL")

    case HTTPoison.get("#{url}/carts/user/#{user_id}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = Poison.decode!(body, as: %Cart{products: [%Product{}]})

        vat = Enum.sum(
          Enum.map(response.products, fn x ->
            Float.floor(List.first(Product.get_vat(x)).percent/100 * x.price * x.amount, 3)
          end)
        )
        JsonHelpers.pretty_json(conn, 200, %{cart_vat: vat})
    end
  end
end
