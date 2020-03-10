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
      client_secret: "c2tfZGEwNWRjOTg2MDVkNGUxZDg4MDU4MmI0ZWU2MjFlODQ6",
      api_env: :sandbox,
      merchant_id: "mjtkrswiqtxftemz4tgl"
    }

    assert state == ConfigState.get_config()
  end
end
