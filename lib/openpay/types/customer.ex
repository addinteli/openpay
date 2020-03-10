defmodule Openpay.Types.Customer do
  @moduledoc """
  Customer Type
  """
  use Ecto.Schema
  import Ecto.Changeset

  @email_validation ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/

  embedded_schema do
    field(:external_id, :string)
    field(:creation_date, :string)
    field(:name, :string, null: false)
    field(:last_name, :string, null: false)
    field(:email, :string)
    field(:requires_account, :boolean, default: false)
    field(:phone_number, :string)
    # address: String.t,
    # clabe: String.t,
    # address: String.t,
    # store
  end

  def to_struct(%Ecto.Changeset{valid?: true} = changeset) do
    apply_changes(changeset)
  end

  def to_json(%__MODULE__{} = m, opts \\ []) do
    m |> Map.from_struct() |> Jason.encode!(opts)
  end

  def changeset(%__MODULE__{} = customer, params) do
    customer
    |> cast(params, [:external_id, :creation_date, :name, :last_name, :email])
    |> validate_required([:name, :email])
    |> validate_format(:email, @email_validation)
  end

  def new_changeset(params) do
    %__MODULE__{}
    |> changeset(params)
  end
end
