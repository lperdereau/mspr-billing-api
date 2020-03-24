defmodule MsprBillingApi.Schemas do
    require OpenApiSpex
    alias OpenApiSpex.Schema

    defmodule Vat do
      OpenApiSpex.schema(%{
          title: "VAT",
          description: "Vat",
          type: :object,
          properties: %{
              type: %Schema{type: :string, description: "type of vat"},
              percentage: %Schema{type: :integer, description: "percentage of vat"}
          },
          required: [:type, :percentage],
          example: %{
              "type" => "normal",
              "percentage" => 20
          }
      })
    end

    defmodule VatsResponse do
        OpenApiSpex.schema(%{
          title: "vat response",
          description: "Response schema for single vat",
          type: :array,
          items: Vat,
          "x-struct": __MODULE__
        })
    end
end
