defmodule Openpay.Webhook do
  @moduledoc """
  This module provides a public API to work with webhooks
  Create a webhook
  Get the webhook info related,
  Delete a webhook,
  List the webhooks related to the commerce.
  """
  alias Openpay.Webhook.Management

  defdelegate create(payload), to: Management
  defdelegate get(id), to: Management
  defdelegate list, to: Management
  defdelegate delete(id), to: Management
end
