defmodule MsprBillingApiWeb.ApiSpec do
    alias OpenApiSpex.{Info, OpenApi, Paths}
    @behaviour OpenApi
  
    @impl OpenApi
    def spec do
      %OpenApi{
        info: %Info{
          title: "Mspr Billing Api",
          version: "1.0"
        },
        servers: [OpenApiSpex.Server.from_endpoint(MsprBillingApiWeb.Endpoint)],
        paths: Paths.from_router(MsprBillingApiWeb.Router)
      }
      |> OpenApiSpex.resolve_schema_modules()
    end
  end