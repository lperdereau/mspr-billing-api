defmodule MsprBillingApi.Billing.Product do
  @moduledoc """
  Product is a model provide by another API
  We use it to get VAT types:
  - normal
  - intermediate
  - reduce
  - super reduce
  """
  defstruct id: "", name: "", vatType: "", price: 0, amount: 0
  alias MsprBillingApi.Billing.Vat

  def get_vat(product) do
    List.first(Vat.get_vat_by_type(product.vatType))
  end
end
