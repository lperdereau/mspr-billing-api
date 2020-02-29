defmodule MsprBillingApi.Billing.Product do
  @moduledoc """
  Product is a model provide by another API
  We use it to get VAT types:
  - normal, code: 4
  - intermediate, code: 3
  - reduce, code: 2
  - super reduce, code: 1
  """
  defstruct name: "", vat_type: 0, price: 0

  def get_vat do
  end
end
