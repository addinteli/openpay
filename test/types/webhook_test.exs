defmodule Types.WebhookTest do
  @moduledoc """
  Testing webhook types
  """
  use ExUnit.Case, async: true
  alias Openpay.Types.Webhook

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

    assert expected == Webhook.list_categories()
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

    assert expected == Webhook.allowed_events_by("charge")

    assert ["subscription.charge.failed"] ==
             Webhook.allowed_events_by("subscription")
  end

  test "should retrieve a list of allowed events with categories" do
    assert {"charge", "charge.refunded"} == Webhook.list_categories_with_events() |> List.first()
  end

  test "should retrieve the list of allowed events" do
    assert "charge.refunded" == Webhook.list_allowed_events() |> List.first()
  end

  test "should retrieve a truthy when event is allowed otherwise it will be falsy" do
    assert Webhook.event_is_allowed?("order.expired")
    refute Webhook.event_is_allowed?("invalid.event")
  end

  test "should retrieve a truthy when all events are allowed, otherwise it will be falsy" do
    assert Webhook.events_are_allowed?([
             "order.expired",
             "payout.created",
             "charge.created"
           ])

    refute Webhook.events_are_allowed?([
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

    assert changeset = Webhook.new_changeset(payload)
    assert changeset.valid?
    assert %Webhook{} = Webhook.to_struct(changeset)
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

    assert changeset = Webhook.new_changeset(payload)
    refute changeset.valid?

    assert changeset.errors == [
             event_types: {"Please check your events almost one of them is invalid.", []}
           ]
  end
end
