defmodule MsprBillingApiWeb.BillingControllerTest do
  use MsprBillingApiWeb.ConnCase
  import Mock
  alias MsprBillingApi.Billing.{Product, Cart, Vat}

  describe "billing endpoint test" do

    test "test :show", %{conn: conn} do
      with_mocks([
        {
          HTTPoison,
          [],
          [get: fn(_url) -> {:ok, %HTTPoison.Response{body:
          "{
            \"createdAt\": 202,
            \"products\": [
              {
                \"amount\": 1,
                \"category\": \"string\",
                \"id\": \"3fa85f64-5717-4562-b3fc-2c963f66afa6\",
                \"name\": \"string\",
                \"price\": 10,
                \"vatType\": \"normal\"
              }
            ],
            \"userId\": \"string\"
          }", status_code: 200}} end]
        },
        {
          Product,
          [:passthrough],
          [get_vat: fn (_product) -> %Vat{type: "normal", percentage: 20} end]
        }
        ]) do
          conn = get(conn, Routes.billing_path(conn, :show, "f2cfb294-4fbb-4ef0-9e17-ac4111d1d120"))
          assert json_response(conn, 200) == %{"cart_vat" => 2.0}
      end
    end
  end
end
