defmodule Openpay.Charge.Store do
  @moduledoc """
  This module intends to work with the Store endpoint.
  """
  alias Openpay.ApiClient, as: Client
  alias Openpay.ConfigState
  alias Openpay.Types

  # add the customer when it will be required
  # deftypestruct Response, ....

  def charge_commerce(%Types.ChargeStore{} = payload) do
    customer =
      payload
      |> get_customer()
      |> Map.from_struct()

    body =
      payload
      |> Map.from_struct()
      |> Map.merge(%{customer: customer})
      |> Map.delete(:id)
      |> Jason.encode!()

    endpoint =
      :api_env
      |> ConfigState.get_config()
      |> Client.get_endpoint()
      |> (&"#{&1}/#{ConfigState.get_config(:merchant_id)}/charges").()

    headers = get_headers()
    options = get_options()

    case Client.post(endpoint, body, headers, options) do
      {:ok, %{status_code: 200} = response} ->
        response.body

      {:ok, %{status_code: _} = response} ->
        response.body
        |> Types.Commons.Error.new_changeset()
        |> Types.Commons.Error.to_struct()
    end
  end

  def get_receipt(reference) do
    :api_env
    |> ConfigState.get_config()
    |> Client.get_endpoint_receipt()
    |> (&"#{&1}/#{ConfigState.get_config(:merchant_id)}/#{reference}").()
  end

  defp get_headers do
    Client.get_headers("Basic #{ConfigState.get_config(:client_secret)}")
  end

  defp get_options, do: Client.get_options()

  defp get_customer(%{customer: nil}), do: default_customer()
  defp get_customer(%{customer: customer}), do: customer

  defp default_customer do
    time = Timex.now()
    {microsecond, _} = time.microsecond
    key = "#{time.second}.#{microsecond}"

    %Types.Customer{
      external_id: "default-#{key}",
      name: "adm",
      last_name: "platform",
      email: "hello@company.com"
    }
  end
end
