defmodule Openpay.ConfigStateTest do
  @moduledoc """
  Test for config state
  """
  use ExUnit.Case, async: true
  alias Openpay.ConfigState
  alias Openpay.Types.Commons.OpenpayConfig

  # setup do
  #   registry = start_supervised!(KV.Registry)
  #   %{registry: registry}
  # end

  test "config was successfully loaded" do
    state = %OpenpayConfig{
      authz: %Openpay.Types.Commons.AuthzConfig{issuers: ["153600"], password: "4wP4Z9NAKKba4S1Wirhi5ccbbkDZGQoU", username: "openpay-auth"},
      client_secret: "c2tfZGEwNWRjOTg2MDVkNGUxZDg4MDU4MmI0ZWU2MjFlODQ6",
      client_public: "cGtfOGZmZWM5M2E2OTcyNDhlODgxY2Q0ZjY3ZDAyN2Y4MWE6",
      api_env: :sandbox,
      merchant_id: "mjtkrswiqtxftemz4tgl"
    }

    assert state == ConfigState.get_config()
  end
end
