defmodule Openpay.Types.Response do
  @moduledoc """
  This module defines the common response types.
  """
  defmodule Customer do
    @moduledoc """
    Define the customer schema response.
    """
    use Ecto.Schema
    # alias Openpay.Utils.Types.Commons
    embedded_schema do
      field(:creation_date, :string)
      field(:name, :string)
      field(:last_name, :string)
      field(:email, :string)
      field(:phone_number, :integer)
      field(:status, :string)
      field(:balance, :string)
      field(:clabe, :string)
      field(:address, :string)
      # field(:store, Store.t())
    end
  end
end
