defmodule Openpay.Types.ChargeStore do
  @moduledoc """
  Charge Store type
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Openpay.Types.Customer
  @timestamps_opts [type: :utc_datetime]

  embedded_schema do
    field(:method, :string, default: "store")
    field(:amount, :float)
    field(:description, :string)
    field(:order_id, :string)
    # DateTime when fix this
    field(:due_date, :utc_datetime)
    embeds_one(:customer, Customer)
  end

  def to_struct(%Ecto.Changeset{valid?: true} = changeset) do
    apply_changes(changeset)
  end

  def to_json(%__MODULE__{} = m, opts \\ []) do
    m |> Map.from_struct() |> date_iso8601(:due_date) |> Jason.encode!(opts)
  end

  def date_iso8601(struct, key) do
    datetime = Map.get(struct, key)
    casted = Map.new([{key, DateTime.to_iso8601(datetime)}])

    Map.merge(struct, casted)
  end

  def changeset(%__MODULE__{} = customer, params) do
    customer
    |> cast(params, [:method, :amount, :description, :order_id, :due_date])
    |> validate_required([:amount, :description])
    |> validate_length(:description, max: 250)
    |> has_customer?(params)
  end

  def new_changeset(params) do
    %__MODULE__{}
    |> changeset(params)
  end

  defp has_customer?(changeset, %{customer: customer}) do
    put_embed(changeset, :customer, customer)
  end

  defp has_customer?(changeset, _params) do
    add_error(changeset, :customer, "The customer is required.")
  end
end
