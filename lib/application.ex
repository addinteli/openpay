defmodule Openpay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    # http_authorizer = case Map.get(Openpay.ConfigState.get_config(), :authz) do
    #   nil -> []
    #   _authz -> [
    #     Plug.Cowboy.child_spec(
    #       scheme: :http,
    #       plug: Openpay.Router,
    #       options: [port: Application.get_env(:openpay, :authz_port)]
    #     )
    #   ]
    # end

    children = [
      Openpay.ConfigState,
      {DynamicSupervisor, name: Openpay.Authz.DynamicSupervisor, strategy: :one_for_one}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Openpay.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
