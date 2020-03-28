defmodule MsprBillingApiWeb.Router do
  use MsprBillingApiWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: MsprBillingApiWeb.ApiSpec
  end

  # coveralls-ignore-start

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  scope "/" do
    pipe_through(:browser)
    get("/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi")
  end
  # coveralls-ignore-stop

  scope "/api" do
    pipe_through :api
    get "/product/:product_id/vat", MsprBillingApiWeb.VatController, :show
    get "/vat/:type", MsprBillingApiWeb.VatController, :show_vat
    get "/vats", MsprBillingApiWeb.VatController, :show_vats

    get "/cart/:user_id/billing", MsprBillingApiWeb.BillingController, :show
    # coveralls-ignore-start
    get "/openapi", OpenApiSpex.Plug.RenderSpec, :show
    # coveralls-ignore-stop
  end
end
