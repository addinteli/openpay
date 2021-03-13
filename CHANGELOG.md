## 0.3.0

### Backwards incompatible changes
  - `Types.RequestCard.CreateToken`was renamed to `Types.Token`.
  - `Types.RequestCard.ChargeIdCardToken` was renamed to `Types.ChargeCard`.
  - `Types.RequestCard.Customer` was removed. no make sense keep it because `Types.Customer` exists.

## 0.2.3

### Enhancements
  - Support `AntiFraud` module, it must be used as part of your HTML.
  - Support `client_public` as part of the `ConfigState`.

## 0.2.2

### Bug fixes
  - Got an `undefined` event during the response from Openpay.

## 0.2.1

### Enhancements
  - Support helpers to retrieve allowed events.

## 0.2.0

### Backwards incompatible changes
  - `Types.Request.ChargeStore` was renamed to `Types.ChargeStore`.
  - `Types.Request.Custom` was renamed to `Types.Customer`.
  - `Types.Commons.ErrorCard` was deleted, use `Types.Commons.Error` instead.

### Enhancements
  - Refactor modules to use `%Ecto.Changeset{}`.
  - Support webhooks management `Openpay.Webhook.create/1`, `Openpay.Webhook.get/1`, `Openpay.Webhook.delete/1` and `Openpay.Webhook.list/0` are available.

## 0.1.0

### Enhancements
  - Charge Store.
  - Charge Card.
