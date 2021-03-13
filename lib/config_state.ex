defmodule Openpay.ConfigState do
  @moduledoc """
  The configuration state.
  """
  use Agent
  alias Openpay.Types.Commons.OpenpayConfig
  import Base, only: [encode64: 1]

  def start_link(_opts) do
    Agent.start_link(fn -> init_state() end, name: __MODULE__)
  end

  def get_config do
    Agent.get(__MODULE__, & &1)
  end

  def get_config(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  defp init_state do
    %OpenpayConfig{
      client_secret: encode64(Application.get_env(:openpay, :client_secret) <> ":"),
      client_public: encode64(Application.get_env(:openpay, :client_public) <> ":"),
      api_env: Application.get_env(:openpay, :api_env),
      merchant_id: Application.get_env(:openpay, :merchant_id)
    }
  end
end
