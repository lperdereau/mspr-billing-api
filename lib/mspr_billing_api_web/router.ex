defmodule MsprBillingApiWeb.Router do
  use MsprBillingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MsprBillingApiWeb do
    pipe_through :api
  end
end
