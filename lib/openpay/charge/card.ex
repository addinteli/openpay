defmodule Openpay.Charge.Card do
  @moduledoc """
  This module intends to work with the token card for generate charges

  NOTE: Before to continue read this https://www.openpay.mx/docs/api/#con-id-de-tarjeta-o-token
  """
  alias Openpay.ApiClient, as: Client
  alias Openpay.ConfigState
  alias Openpay.Types

  # add the customer when it will be required
  # deftypestruct Response, ....

  def create_token(%Types.Token{} = payload) do
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
        response.body
        |> Types.Commons.Error.new_changeset()
        |> Types.Commons.Error.to_struct()
    end
  end

  def charge(%Types.ChargeCard{} = payload) do
    customer =
      payload
      |> get_customer()

    payment_plan =
      payload
      |> get_payment_plan

    body =
      payload
      |> Map.from_struct()
      |> Map.merge(customer)
      |> Map.merge(payment_plan)
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


  defp get_headers do
    Client.get_headers("Basic #{ConfigState.get_config(:client_secret)}")
  end

  defp get_options, do: Client.get_options()

  defp get_customer(%{customer: nil}), do: %{customer: Map.from_struct(default_customer())}
  defp get_customer(%{customer: customer}), do: %{customer: Map.from_struct(customer)}

  defp get_payment_plan(%{payment_plan: nil}), do: %{}
  defp get_payment_plan(%{payment_plan: payment_plan}), do: %{customer: Map.from_struct(payment_plan)}

  defp default_customer do
    %Types.Customer{
      name: "Joe",
      last_name: "Doe",
      email: "joe@doe.com",
      phone_number: "1000201035"
    }
  end
end
