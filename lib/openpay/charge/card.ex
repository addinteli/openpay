defmodule Openpay.Charge.Card do
  @moduledoc """
  This module intends to work with the token card for generate charges

  NOTE: Before to continue read this https://www.openpay.mx/docs/api/#con-id-de-tarjeta-o-token
  """
  alias Openpay.ApiClient, as: Client
  alias Openpay.ConfigState
  alias Openpay.Types
  alias Openpay.Utils.Commons

  # add the customer when it will be required
  # deftypestruct Response, ....

  def create_token(%Types.RequestCard.CreateToken{} = payload) do
    body =
      payload
      |> Map.from_struct()
      |> Jason.encode!()

    endpoint =
      :api_env
      |> ConfigState.get_config()
      |> Client.get_endpoint()
      |> (&"#{&1}/#{ConfigState.get_config(:merchant_id)}/tokens").()

    headers = get_headers()
    options = get_options()

    case Client.post(endpoint, body, headers, options) do
      {:ok, %{status_code: 201} = response} ->
        response.body

      {:ok, %{status_code: _} = response} ->
        Commons.into(Types.Commons.ErrorCard, response.body)
    end
  end

  def charge(%Types.RequestCard.ChargeIdCardToken{} = payload) do
    customer =
      payload
      |> get_customer()
      |> Map.from_struct()

    body =
      payload
      |> Map.from_struct()
      |> Map.merge(%{customer: customer})
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
        Commons.into(Types.Commons.ErrorCard, response.body)
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
    %Types.RequestCard.Customer{
      name: "Luis",
      last_name: "Santiago",
      email: "luis@santiago.com",
      phone_number: "97111451178"
    }
  end
end
