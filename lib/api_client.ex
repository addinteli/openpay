defmodule Openpay.ApiClient do
  @moduledoc """
  This module is an Api Client
  """
  use HTTPoison.Base

  alias Openpay.Utils.Commons

  @doc """
  Processing URL
  """
  def process_url(url) do
    url
  end

  def process_response_body(nil), do: nil
  def process_response_body(""), do: ""

  def process_response_body(body) do
    body
    |> Jason.decode!()
    |> Commons.map_to_atom()
  end

  def process_headers(headers) do
    headers
    |> Commons.from_json()
  end

  def get_endpoint(:sandbox) do
    "https://sandbox-api.openpay.mx/v1"
  end

  def get_endpoint(:prod) do
    "https://api.openpay.mx/v1"
  end

  def get_endpoint_receipt(:sandbox) do
    "https://sandbox-dashboard.openpay.mx/paynet-pdf"
  end

  def get_endpoint_receipt(:prod) do
    "https://dashboard.openpay.mx/paynet-pdf"
  end

  def get_headers(auth) do
    [
      Authorization: auth,
      "Content-Type": "application/json",
      Accept: "application/json; Charset=utf-8"
    ]
  end

  def get_options(timeout \\ 10_000) do
    [
      ssl: [{:versions, [:"tlsv1.2"]}],
      recv_timeout: timeout
    ]
  end
end
