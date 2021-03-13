defmodule Openpay.AntiFraud do
  @moduledoc """
  Openpay AntiFraud

  Don't try to use directly they need to be used embedded in your HTML otherwise they won't work as you expect.

  If you are unsure how to use them, refer to `Openpay.AntiFraud.Helpers` this module brings you the way to do it quickly and easily.
  """
  alias Openpay.ApiClient, as: Client
  alias Openpay.ConfigState

  @doc """
  Components there are iframes which need to be injected
  in the HTML.
  """
  def get_components(device_session_id) do
    endpoint =
      :api_env
      |> ConfigState.get_config()
      |> Client.get_endpoint()
      |>  String.replace("v1", "antifraud")
      |> (&"#{&1}/#{ConfigState.get_config(:merchant_id)}/components").()

    headers = [
      "Content-Type": "text/html;charset=UTF-8"
    ]
    options = Client.get_options() ++ [params: %{s: device_session_id}]

    case HTTPoison.get(endpoint, headers, options) do
      {:ok, response} ->
        response.body
        |> String.replace("\n", "")
    end
  end

  @doc """
  Based on your merchant it gets a valid key.
  """
  def get_antifraud_key do
    endpoint =
      :api_env
      |> ConfigState.get_config()
      |> Client.get_endpoint()
      |> (&"#{&1}/#{ConfigState.get_config(:merchant_id)}/antifraudkeys").()

    headers = Client.get_headers("Basic #{ConfigState.get_config(:client_public)}")
    options = Client.get_options()

    case HTTPoison.get(endpoint, headers, options) do
      {:ok, response} ->
        response.body
        |> String.replace("(", "")
        |> String.replace(")", "")
        |> Jason.decode!()
    end
  end

  @doc """
  Get an strong device session based on openpay rules.
  """
  def get_device_session_id do
    :crypto.strong_rand_bytes(32)
    |> Base.encode64()
    |> binary_part(0, 32)
    |> String.replace(~r/[\+\/]/, "0")
  end
end
