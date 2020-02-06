defmodule Openpay.Types.RequestCard do
  @moduledoc """
  This module defines the common request types.
  """

  defmodule Customer do
    @moduledoc """
    Define the customer request schema to enforce the correct request.
    """
    use Ecto.Schema
    alias Openpay.Types.RequestCard.Customer

    @primary_key false
    embedded_schema do
      field(:name, :string, null: false)
      field(:last_name, :string, null: false)
      field(:email, :string, null: false)
      field(:phone_number, :string)
    end
  end

  defmodule CreateToken do
    @moduledoc """
    Charge Type, create token for openpay and return id_token
    """

    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:holder_name, :string)
      field(:card_number, :string)
      field(:expiration_month, :string)
      field(:expiration_year, :string)
      field(:cvv2, :string)
    end
  end

  defmodule ChargeIdCardToken do
    @moduledoc """
    Charge Type, used by charge a commerce or a cliente
    """

    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:method, :string, default: "card")
      field(:source_id, :string)
      field(:amount, :float)
      field(:cvv2, :integer)
      field(:currency, :string)
      field(:description, :string)
      field(:order_id, :string)
      field(:device_session_id, :string)
      belongs_to(:customer, Customer)
    end
  end
end
