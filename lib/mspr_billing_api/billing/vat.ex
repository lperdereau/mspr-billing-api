defmodule MsprBillingApi.Billing.Vat do
  @moduledoc """
  Provides vat-related functions.
  """

  @moduledoc since: "v0.0.1"

  @doc """
  Allow you to initialiaze Mnesia table for VAT

  ## Exemples
      alias MsprBillingApi.Billing.Vat
      Vat.create_table()
  """
  @doc since: "v0.0.1"
  def create_table() do
    :mnesia.create_table(:vat, [attributes: [:type, :percentage]])
  end

  @doc """
  Allow you to create VAT in Mnesia database

  ## Exemples
      alias MsprBillingApi.Billing.Vat
      Vat.insert_vat()
  """
  @doc since: "v0.0.1"
  def insert_vat() do
    :mnesia.transaction(fn ->
      :mnesia.write({:vat, "normal", 20})
      :mnesia.write({:vat, "intermediary", 10})
      :mnesia.write({:vat, "reduce", 5.5})
      :mnesia.write({:vat, "super_reduce", 2.1})
    end)
  end

  @doc """
  Allow you to get VAT by type code

  ## Exemples
      iex> alias MsprBillingApi.Billing.Vat
      iex> type = "normal"
      iex> Vat.get_vat_by_type(type)
      [%{percent: 20, type: "normal"}]
  """
  @doc since: "v0.0.1"
  def get_vat_by_type(type) do
    object = fn ->
      :mnesia.select(:vat,[{{:vat,:"$1",:"$2"},[{:==,:"$1",type}],[%{type: :"$1", percent: :"$2"}]}])
    end
    {_atomic, result} = :mnesia.transaction(object)
    result
  end

  @doc """
  Allow you to get all VATs

  ## Exemples
      iex> alias MsprBillingApi.Billing.Vat
      iex> Vat.get_vats()
      [
        %{percent: 20, type: "normal"},
        %{percent: 10, type: "intermediary"}
      ]
  """
  @doc since: "v0.0.1"
  def get_vats() do
    object = fn ->
      :mnesia.select(:vat,[{{:vat,:"$1",:"$2"},[],[%{type: :"$1", percent: :"$2"}]}])
    end
    {_atomic, result} = :mnesia.transaction(object)
    result
  end

  def get_vat_info() do
    :mnesia.table_info(:vat, :attributes)
  end
end
