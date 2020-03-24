defmodule MsprBillingApiWeb.Router do
  use MsprBillingApiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: MsprBillingApiWeb.ApiSpec
  end

  scope "/" do
    pipe_through(:browser)
    get("/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi")
  end

  scope "/api" do
    pipe_through :api
    get "/product/:product_id/vat", MsprBillingApiWeb.VatController, :show
    get "/vat/:type", MsprBillingApiWeb.VatController, :show_vat
    get "/vats", MsprBillingApiWeb.VatController, :show_vats

    get "/cart/:user_id/billing", MsprBillingApiWeb.BillingController, :show

    get("/openapi", OpenApiSpex.Plug.RenderSpec, :show) 
  end
end
