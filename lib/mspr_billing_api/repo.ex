defmodule MsprBillingApi.Repo do
  use Ecto.Repo,
    otp_app: :mspr_billing_api,
    adapter: Ecto.Adapters.Postgres
end
