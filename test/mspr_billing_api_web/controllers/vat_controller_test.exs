defmodule MsprBillingApiWeb.VatControllerTest do
  use MsprBillingApiWeb.ConnCase
  import Mock
  alias MsprBillingApi.Billing.Vat

  # setup %{conn: conn} do
  #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
  # end

  describe "show_vats" do

    test "no vats", %{conn: conn} do
      with_mock Vat,
      [get_vats: fn() ->
        []
      end] do
        conn = get(conn, Routes.vat_path(conn, :show_vats))
        assert json_response(conn, 404)["msg"] == "vat not found with this id"
      end
    end

    test "some vats", %{conn: conn} do
      with_mock Vat,
      [get_vats: fn() ->
        [%Vat{type: "normal", percentage: 20}, %Vat{type: "intermediary", percentage: 10} ]
      end] do
        conn = get(conn, Routes.vat_path(conn, :show_vats))
        assert json_response(conn, 200) == [%{"type" => "normal", "percentage" => 20},%{"type" => "intermediary", "percentage" => 10}]
      end
    end

  end

  describe "show" do

    test "product found", %{conn: conn} do
      uuid = "75aeeedb-4f0e-4234-a268-d83fffc548a1"
      body = "{
        \"desciption\": \"useless product\",
        \"id\": \"#{uuid}\",
        \"logoUrl\": \"https://bit.ly/2UBsFxQ\",
        \"name\": \"Product\",
        \"price\": 500,
        \"vatType\": \"normal\"
        }"

      with_mocks([
        {
          HTTPoison,
          [],
          [get: fn(_url) -> {:ok, %HTTPoison.Response{body: body, status_code: 200}} end]
        },
        {
          Vat,
          [],
          [get_vat_by_type: fn(_type) -> [%Vat{type: "normal", percentage: 20}]end]
        }
        ]) do
          conn = get(conn,Routes.vat_path(conn, :show, uuid))
          assert json_response(conn,200) == %{"type" => "normal", "percentage" => 20}
        end
    end

    test "product not found", %{conn: conn} do
      uuid = "75aeeedb-4f0e-4234-a268-d83fffc548a1"
      body = "{}"

      with_mock HTTPoison,
        [get: fn(_url) -> {:ok, %HTTPoison.Response{body: body, status_code: 404}} end] do
          conn = get(conn,Routes.vat_path(conn, :show, uuid))
          assert json_response(conn,404)["msg"] == "product not found with this id"
				end
    end


    test "product error on http request", %{conn: conn} do
      uuid = "75aeeedb-4f0e-4234-a268-d83fffc548a1"
      body = "{}"

      with_mock HTTPoison,
        [get: fn(_url) -> {:error, %HTTPoison.Response{body: body, status_code: 404}} end] do
          conn = get(conn,Routes.vat_path(conn, :show, uuid))
          assert json_response(conn,500)["message"] == "Error"
				end
    end

    test "code http", %{conn: conn} do
      uuid = "75aeeedb-4f0e-4234-a268-d83fffc548a1"
      body = "{}"

      with_mock HTTPoison,
        [get: fn(_url) -> {:ok, %HTTPoison.Response{body: body, status_code: 500}} end] do
          conn = get(conn,Routes.vat_path(conn, :show, uuid))
          assert json_response(conn,500)["message"] == "Error"
				end
    end
  end

  describe "show_vat" do

		test "vat not found", %{conn: conn} do
			with_mock Vat,
				[get_vat_by_type: fn(_type) -> [
				]
				end]do
			conn = get(conn, Routes.vat_path(conn, :show_vat, "normal"))
			assert json_response(conn,404)["msg"] == "vat not found with this id"
			end
		end

		test "vat found", %{conn: conn} do
			with_mock Vat,
			[get_vat_by_type: fn(_type) -> [
				%Vat{type: "normal", percentage: 20}
			]
			end] do
        conn = get(conn, Routes.vat_path(conn, :show_vat, "normal"))
        assert json_response(conn,200) == %{"type" => "normal", "percentage" => 20}
      end
		end

		test "multiple vat found", %{conn: conn} do
			with_mock Vat,
			[get_vat_by_type: fn(_type) -> [
				%Vat{type: "normal", percentage: 20}, %Vat{type: "normal", percentage: 40}
			]
			end] do
        conn = get(conn, Routes.vat_path(conn, :show_vat, "normal"))
        assert json_response(conn,500)["message"] == "Error"
      end
		end

  end

end
