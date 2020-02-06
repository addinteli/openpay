defmodule Openpay.Types.ResponseCard do
  @moduledoc """
  This module defines the common response types.
  """
  defmodule CreateToken do
    @moduledoc """
    Define the customer schema response.
    """
    use Ecto.Schema

    embedded_schema do
      field(:type, :string)
      field(:brand, :string)
      field(:card_number, :string)
      field(:holder_name, :string)
      field(:expiration_year, :integer)
      field(:expiration_mount, :string)
      field(:bank_name, :string)
      field(:customer_id, :string)
      field(:bank_code, :string)
    end
  end

  defmodule Customer do
    @moduledoc """
    Define the customer schema response.
    """
    use Ecto.Schema

    embedded_schema do
      field(:name, :string)
      field(:last_name, :string)
      field(:email, :string)
      field(:phone_number, :integer)
    end
  end
end
