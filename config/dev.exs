import Config

config :openpay,
  client_secret: "sk_ecd2d6bcf4db4c75a5f766d15f86899b",
  api_env: :sandbox,
  merchant_id: "mjtkrswiqtxftemz4tgl",
  webhook_auth: [
    username: "webhook-openpay",
    password: "this_is_the_password"
  ],
  authorizer_auth: [
    username: "openpay-auth",
    password: "4wP4Z9NAKKba4S1Wirhi5ccbbkDZGQoU",
    issuers: ["153600"]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
