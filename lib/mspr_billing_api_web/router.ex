defmodule MsprBillingApiWeb.Router do
  use MsprBillingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MsprBillingApiWeb do
    pipe_through :api
    get "/product/:product_id/vat", VatController, :show
    get "/vat/:type", VatController, :show_vat
    get "/vats", VatController, :show_vats

    get "/cart/:user_id/billing", BillingController, :show
  end
end
