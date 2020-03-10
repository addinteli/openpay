## 0.2.0

### Backwards incompatible changes
  - `Types.Request.ChargeStore` was renamed to `Types.ChargeStore`
  - `Types.Request.Custom` was renamed to `Types.Customer`
  - `Types.Commons.ErrorCard` was deleted, use `Types.Commons.Error` instead.

### Enhancements
  - Refactor modules to use %Ecto.Changeset{}.
  - Support webhooks management `Openpay.Webhook.create/1`, `Openpay.Webhook.get/1`, `Openpay.Webhook.delete/1` and `Openpay.Webhook.list/0` are available.

## 0.1.0

### Enhancements
  - Charge Store
  - Charge Card