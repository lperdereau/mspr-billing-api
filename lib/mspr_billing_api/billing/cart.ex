defmodule MsprBillingApi.Billing.Cart do
  @moduledoc """
  Product is a model provide by another API
  We use it to get VAT types:
  - normal
  - intermediate
  - reduce
  - super reduce
  """
  alias MsprBillingApi.Billing.Product

  defstruct userId: "", createdAt: 0, products: [%Product{}]

  def get_vat(cart) do
    Enum.sum(
      Enum.map(cart.products, fn x ->
        Float.floor(Product.get_vat(x).percentage/100 * x.price * x.amount, 3)
      end)
    )
  end
end
