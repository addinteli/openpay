defmodule Openpay.Types.Webhook do
  @moduledoc """
  Types for webhook, request and response
  """
  use Ecto.Schema
  import Ecto.Changeset
  # details at https://www.openpay.mx/docs/api/#objeto-webhook
  @allowed_events [
    "charge.refunded",
    "charge.failed",
    "charge.cancelled",
    "charge.created",
    "charge.succeeded",
    "charge.rescored.to.decline",
    "subscription.charge.failed",
    "payout.created",
    "payout.succeeded",
    "payout.failed",
    "transfer.succeeded",
    "fee.succeeded",
    "fee.refund.succeeded",
    "spei.received",
    "chargeback.created",
    "chargeback.rejected",
    "chargeback.accepted",
    "order.created",
    "order.activated",
    "order.payment.received",
    "order.completed",
    "order.expired",
    "order.cancelled",
    "order.payment.cancelled"
  ]

  embedded_schema do
    field(:url, :string)
    field(:user, :string)
    field(:password, :string)
    field(:event_types, {:array, :string})
    field(:status, :string)
    field(:allow_redirects, :boolean)
    field(:force_host_ssl, :boolean)
  end

  def changeset(%__MODULE__{} = webhook, params) do
    events = Map.get(params, :event_types, [])

    webhook
    |> cast(params, [
      :id,
      :allow_redirects,
      :force_host_ssl,
      :status,
      :url,
      :user,
      :password,
      :event_types
    ])
    |> validate_required([:url, :user, :password, :event_types])
    |> validate_event_types(events, events_are_allowed?(events))
  end

  def new_changeset(params) do
    %__MODULE__{}
    |> changeset(params)
  end

  def get_changeset(params) do
    events = Map.get(params, :event_types, [])

    %__MODULE__{}
    |> cast(params, [:id, :allow_redirects, :force_host_ssl, :status, :url, :user, :event_types])
    |> validate_required([:url, :user, :event_types])
    |> validate_event_types(events, events_are_allowed?(events))
  end

  def to_struct(%Ecto.Changeset{valid?: true} = changeset) do
    apply_changes(changeset)
  end

  def to_json(%__MODULE__{} = m, opts \\ []) do
    m |> Map.from_struct() |> Jason.encode!(opts)
  end

  def validate_event_types(changeset, events, true) do
    put_change(changeset, :event_types, events)
  end

  def validate_event_types(changeset, _events, false) do
    add_error(changeset, :event_types, "Please check your events almost one of them is invalid.")
  end

  def list_categories do
    @allowed_events
    |> Enum.map(&string_first/1)
    |> Enum.uniq()
  end

  def allowed_events_by(category) do
    @allowed_events
    |> Enum.filter(fn item -> string_first(item) == category end)
  end

  def event_is_allowed?(event) when is_bitstring(event), do: event in @allowed_events

  def events_are_allowed?(events) when is_list(events),
    do: Enum.all?(events, &event_is_allowed?/1)

  defp string_first(str, pattern \\ ".") do
    str |> String.split(pattern) |> List.first()
  end
end
