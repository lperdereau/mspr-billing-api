defmodule Mix.Tasks.MsprBillingApiWeb.OpenApiSpec do
    def run([]) do
      MsprBillingApiWeb.Endpoint.start_link()
  
      MsprBillingApiWeb.ApiSpec.spec()
      |> Jason.encode!(pretty: true, maps: :strict)
      |> (&File.write!("openapi3_v1.0.json", &1)).()
    end
  end