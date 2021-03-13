defmodule Openpay.Types.ChargeCard do
  @moduledoc """
  Charge Store type

  Not supported card points.
  Not supported 3D secure
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Openpay.Utils.ExtraValidations

  alias Openpay.Types.Customer
  @timestamps_opts [type: :utc_datetime]
  @primary_key false
  embedded_schema do
    field(:method, :string, default: "card")
    field(:amount, :float)
    field(:description, :string)
    field(:order_id, :string)
    # Card ID if it exists otherwise token generated previously.
    field(:source_id, :string)
    # Card security code
    field(:cvv2, :integer)
    field(:currency, :string)
    # anti-fraud token
    field(:device_session_id, :string)
    # flag to apply charge as pre-authorization or immediately.
    field(:capture, :boolean, default: true)
    # optionals because they archive other workflows.

    embeds_one(:customer, Customer)

    # data for apply months without interest.

    embeds_one :payment_plan, PaymentPlan do
      field :payments, :string
    end

    # metadata usable to create custom anti fraud rules.
    field(:metadata, {:array, :map})

  end

  def to_struct(%Ecto.Changeset{valid?: true} = changeset) do
    apply_changes(changeset)
  end

  def to_json(%__MODULE__{} = m, opts \\ []) do
    m |> Map.from_struct() |> Jason.encode!(opts)
  end

  def new_changeset(params) do
    %__MODULE__{}
    |> changeset(params)
  end

  def changeset(%__MODULE__{} = charge_to_card, params) do
    required = [:method, :amount, :description, :order_id, :source_id, :cvv2, :currency, :device_session_id]
    optional = [:device_session_id, :capture, :metadata]

    charge_to_card
    |> cast(params, required ++ optional)
    |> validate_required(required)
    |> validate_length(:description, max: 250)
    |> validate_length_in(:cvv2, [3, 4])
    |> validate_inclusion(:currency, ~w(MXN USD))
    |> has_customer?(params)
    |> has_payment_plan(params)
  end


  defp has_customer?(changeset, %{customer: customer}) do
    put_embed(changeset, :customer, customer)
  end

  defp has_customer?(changeset, _params) do
    add_error(changeset, :customer, "The customer is required.")
  end

  defp has_payment_plan(changeset, %{payment_plan: _value}) do
    cast_embed(changeset, :payment_plan, with: &payment_plan_changeset/2)
  end

  defp has_payment_plan(changeset, _params), do: changeset

  defp payment_plan_changeset(schema, params) do
    schema
    |> cast(params, [:payments])
    |> validate_inclusion(:payments, ~w(3 6 9 12 18))
  end
end
