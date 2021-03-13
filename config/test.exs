import Config

config :openpay,
  client_secret: "sk_da05dc98605d4e1d880582b4ee621e84",
  client_public: "pk_8ffec93a697248e881cd4f67d027f81a",
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

# Print only warnings and errors during test
config :logger, level: :warn
