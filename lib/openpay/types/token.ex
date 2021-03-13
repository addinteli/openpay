defmodule Openpay.Types.Token do
    @moduledoc """
    Required schema to create a token it return id_token and it will be used
    as
    """
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field(:holder_name, :string)
      field(:card_number, :string)
      field(:expiration_month, :string)
      field(:expiration_year, :string)
      field(:cvv2, :string)
    end

    def new_changeset(params) do
      %__MODULE__{}
      |> changeset(params)
    end

    def changeset(%__MODULE__{} = token, params) do
      required = [:holder_name, :card_number, :expiration_month, :expiration_year, :cvv2]

      token
      |> cast(params, required)
      |> validate_required(required)
    end

    def to_struct(%Ecto.Changeset{valid?: true} = changeset), do: apply_changes(changeset)
    def to_struct(changeset), do: changeset
end
