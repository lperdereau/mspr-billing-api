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

  defstruct userId: "", createdAt: 0, products: [{%Product{}, amount: 0}]
  alias MsprBillingApi.Billing.Vat

  def get_vat(product) do
    Vat.get_vat_by_type(product.vatType)
  end
end
