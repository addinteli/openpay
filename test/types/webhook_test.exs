defmodule Types.WebhookTest do
  @moduledoc """
  Testing webhook types
  """
  use ExUnit.Case, async: true

  test "should get categories" do
    expected = [
      "charge",
      "subscription",
      "payout",
      "transfer",
      "fee",
      "spei",
      "chargeback",
      "order"
    ]

    assert expected == Openpay.Types.Webhook.list_categories()
  end

  test "should retrieve allowed events passing the category" do
    expected = [
      "charge.refunded",
      "charge.failed",
      "charge.cancelled",
      "charge.created",
      "charge.succeeded",
      "charge.rescored.to.decline"
    ]

    assert expected == Openpay.Types.Webhook.allowed_events_by("charge")

    assert ["subscription.charge.failed"] ==
             Openpay.Types.Webhook.allowed_events_by("subscription")
  end

  test "should retrieve a truthy when event is allowed otherwise it will be falsy" do
    assert Openpay.Types.Webhook.event_is_allowed?("order.expired")
    refute Openpay.Types.Webhook.event_is_allowed?("invalid.event")
  end

  test "should retrieve a truthy when all events are allowed, otherwise it will be falsy" do
    assert Openpay.Types.Webhook.events_are_allowed?([
             "order.expired",
             "payout.created",
             "charge.created"
           ])

    refute Openpay.Types.Webhook.events_are_allowed?([
             "order.expired",
             "payout.created",
             "invalid.event"
           ])
  end

  test "should retrieve a valid changeset" do
    payload = %{
      url: "https://webhooks.paridin.com/openpay",
      user: "whopenpay",
      password: "this_is_the_password",
      event_types: [
        "charge.created",
        "charge.succeeded"
      ]
    }

    assert changeset = Openpay.Types.Webhook.new_changeset(payload)
    assert changeset.valid?
    assert %Openpay.Types.Webhook{} = Openpay.Types.Webhook.to_struct(changeset)
  end

  test "should retrieve an invalid changeset" do
    payload = %{
      url: "https://webhooks.paridin.com/openpay",
      user: "whopenpay",
      password: "this_is_the_password",
      event_types: [
        "charge.created",
        "invalid.type"
      ]
    }

    assert changeset = Openpay.Types.Webhook.new_changeset(payload)
    refute changeset.valid?

    assert changeset.errors == [
             event_types: {"Please check your events almost one of them is invalid.", []}
           ]
  end
end
