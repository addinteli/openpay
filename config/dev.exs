import Config

config :openpay,
  client_secret: "sk_da05dc98605d4e1d880582b4ee621e84",
  api_env: :sandbox,
  merchant_id: "mjtkrswiqtxftemz4tgl",
  webhook_auth: [
    username: "FSQ82bKTqCTI4hr6w",
    password: "aBGVWR0eK1s56zYDfoFEsHuaZqaPxzUkRz"
  ],
  authorizer_auth: [
    username: "openpay-auth",
    password: "4wP4Z9NAKKba4S1Wirhi5ccbbkDZGQoU",
    issuers: ["153600"]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
