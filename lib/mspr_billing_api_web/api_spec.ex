defmodule MsprBillingApiWeb.ApiSpec do
    alias OpenApiSpex.{Info, OpenApi, Paths}
    @behaviour OpenApi

    @impl OpenApi
    def spec do
      %OpenApi{
        info: %Info{
          title: "Mspr Billing Api",
          version: List.to_string(Application.spec(:mspr_billing_api, :vsn))
        },
        servers: [OpenApiSpex.Server.from_endpoint(MsprBillingApiWeb.Endpoint)],
        paths: Paths.from_router(MsprBillingApiWeb.Router)
      }
      |> OpenApiSpex.resolve_schema_modules()
    end
  end
