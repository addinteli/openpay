defmodule Openpay.ConfigState do
  @moduledoc """
  The configuration state.
  """
  use Agent
  alias Openpay.Types.Commons.{AuthzConfig, OpenpayConfig}
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
      merchant_id: Application.get_env(:openpay, :merchant_id),
      authz: :openpay
        |> Application.get_env(:authorizer_auth)
        |> get_authorizer_info()
    }
  end

  defp get_authorizer_info(nil), do: nil

  defp get_authorizer_info([username: username, password: password, issuers: issuers]) when is_list(issuers) do
    params = %{
      username: username,
      password: password,
      issuers: issuers
    }
    response =
      %AuthzConfig{}
      |> AuthzConfig.changeset(params)
      |> AuthzConfig.apply_config()

    case response do
      {:ok, config} -> config
      {:error, changeset} -> raise(ArgumentError, "#{inspect(changeset.errors)}")
    end
  end

  defp get_authorizer_info(_) do
    error_message = """
    Please be sure you are setup the username, password and issuers inside of openpay.authorizer_auth config

    config :openpay,
      authorizer_auth: [
        username: "my-basic-auth-openpay-username",
        password: "my-basic-auth-strong-password",
        issuers: ["000000"]
      ]

    Note: the issuer must be provided by openpay.
    """
    raise(ArgumentError, error_message)
  end
end
