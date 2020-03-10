defmodule Openpay.Webhook.Management do
  @moduledoc """
  This module is the client to work with the openpay API.
  """
  alias Openpay.ApiClient, as: Client
  alias Openpay.ConfigState
  alias Openpay.Types

  def create(%Types.Webhook{} = payload) do
    # POST https://sandbox-api.openpay.mx/v1/{MERCHANT_ID}/webhooks
    body =
      payload
      |> Map.delete(:id)
      |> Types.Webhook.to_json()

    endpoint =
      :api_env
      |> ConfigState.get_config()
      |> Client.get_endpoint()
      |> (&"#{&1}/#{ConfigState.get_config(:merchant_id)}/webhooks").()

    headers = get_headers()
    options = get_options()

    case Client.post(endpoint, body, headers, options) do
      {:ok, %{status_code: 200} = response} -> to_webhook(response.body, :get)
      {:ok, %{status_code: 201} = response} -> to_webhook(response.body, :get)
      {:ok, %{status_code: _} = response} -> to_error(response.body)
    end
  end

  def get(id) when is_bitstring(id) do
    endpoint =
      :api_env
      |> ConfigState.get_config()
      |> Client.get_endpoint()
      |> (&"#{&1}/#{ConfigState.get_config(:merchant_id)}/webhooks/#{id}").()

    headers = get_headers()
    options = get_options()

    case Client.get(endpoint, headers, options) do
      {:ok, %{status_code: 200} = response} -> to_webhook(response.body, :get)
      {:ok, %{status_code: 201} = response} -> to_webhook(response.body, :get)
      {:ok, %{status_code: _} = response} -> to_error(response.body)
    end
  end

  def delete(id) when is_bitstring(id) do
    endpoint =
      :api_env
      |> ConfigState.get_config()
      |> Client.get_endpoint()
      |> (&"#{&1}/#{ConfigState.get_config(:merchant_id)}/webhooks/#{id}").()

    headers = get_headers()
    options = get_options()

    case Client.delete(endpoint, headers, options) do
      {:ok, %{status_code: 200} = response} ->
        response.body

      {:ok, %{status_code: 201} = response} ->
        response.body

      {:ok, %{status_code: 204} = response} ->
        response.body

      {:ok, %{status_code: _} = response} ->
        to_error(response.body)
    end
  end

  # list
  def list do
    endpoint =
      :api_env
      |> ConfigState.get_config()
      |> Client.get_endpoint()
      |> (&"#{&1}/#{ConfigState.get_config(:merchant_id)}/webhooks").()

    headers = get_headers()
    options = get_options()

    case Client.get(endpoint, headers, options) do
      {:ok, %{status_code: 200} = response} -> list_of_webhooks(response.body)
      {:ok, %{status_code: 201} = response} -> list_of_webhooks(response.body)
      {:ok, %{status_code: _} = response} -> to_error(response.body)
    end
  end

  # privates
  defp get_headers do
    Client.get_headers("Basic #{ConfigState.get_config(:client_secret)}")
  end

  defp get_options, do: Client.get_options()

  defp list_of_webhooks(body) do
    body
    |> Enum.map(&to_webhook(&1, :get))
  end

  defp to_error(params) do
    params
    |> Types.Commons.Error.new_changeset()
    |> Types.Commons.Error.to_struct()
  end

  defp to_webhook(params, :get) do
    params
    |> Types.Webhook.get_changeset()
    |> Types.Webhook.to_struct()
  end
end
