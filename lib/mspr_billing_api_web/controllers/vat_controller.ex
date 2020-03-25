defmodule MsprBillingApiWeb.VatController do
  use MsprBillingApiWeb, :controller
  require OpenApiSpex
  import OpenApiSpex.Operation
  alias OpenApiSpex.Operation
  alias OpenApiSpex.Schema
  alias MsprBillingApiWeb.{JsonHelpers, Gettext}
  alias MsprBillingApi.Billing.{Vat, Product}
  alias MsprBillingApi.Schemas

  @notFoundId "%{ressource} not found with this id"

  plug OpenApiSpex.Plug.CastAndValidate

  def open_api_operation(action) do
    apply(__MODULE__, :"#{action}_operation", [])
  end

  def show_operation() do
    %Operation{
      tags: ["VAT"],
      summary: "product's vat",
      description: "vat of product",
      operationId: "vatcontroller.show",
      parameters: [
        Operation.parameter(:product_id, :path, :string, "product ID", example: 1)
      ],
      responses: %{
        200 => response("vat", "application/json", Schemas.Vat)
      }
    }
  end

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

  def show_vat_operation() do
    %Operation{
      tags: ["VAT"],
      summary: "product's vat",
      description: "vat of product",
      operationId: "vatcontroller.show",
      responses: %{
        200 => response("vat", "application/json", Schemas.Vat)
      }
    }
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

  def show_vats_operation() do
    %Operation{
      tags: ["VAT"],
      summary: "product's vat",
      description: "vat of product",
      operationId: "vatcontroller.show",
      responses: %{
        200 => response("vat", "application/json", %OpenApiSpex.Schema{
          type: :array,
          items: Schemas.Vat
        })
      }
    }
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
