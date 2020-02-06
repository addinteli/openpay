defmodule Openpay.Types.Request do
  @moduledoc """
  This module defines the common request types.
  """

  # alias Openpay.Utils.Types.Commons

  defmodule Customer do
    @moduledoc """
    Define the customer request schema to enforce the correct request.
    """
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:external_id, :string, null: false)
      field(:creation_date, :string)
      field(:name, :string, null: false)
      field(:last_name, :string, null: false)
      field(:email, :string, null: false)
      field(:requires_account, :boolean, default: false)
      field(:phone_number, :string)
      # address: String.t,
      # clabe: String.t,
      # address: String.t,
      # store
    end
  end

  defmodule ChargeStore do
    @moduledoc """
    Charge Type, used by charge a commerce or a cliente
    """

    alias Openpay.Types.Request.Customer
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:method, :string, default: "store")
      field(:amount, :float)
      field(:description, :string)
      field(:order_id, :string)
      # DateTime when fix this
      field(:due_date, :string)
      belongs_to(:customer, Customer)
    end
  end
end
