defmodule Openpay.Types.Commons do
  @moduledoc """
  This module defines the common types from the api.
  """

  defmodule OpenpayConfig do
    @moduledoc """
    Openpay Config type
    """
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:client_secret, :string)
      field(:client_public, :string)
      field(:api_env, :string)
      field(:merchant_id, :string)
    end
  end

  defmodule Error do
    @moduledoc """
    Openpay Error Object
    """
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field(:category, :string)
      field(:error_code, :integer)
      field(:description, :string)
      field(:http_code, :integer)
      field(:request_id, :string)
      field(:fraud_rules, {:array, :string}, default: [])
    end
    def changeset(%__MODULE__{} = error, params) do
      error
      |> cast(params, [
        :category,
        :error_code,
        :description,
        :http_code,
        :request_id,
        :fraud_rules
      ])
      |> validate_required([:category, :error_code, :description, :http_code])
    end
    def new_changeset(params) do
      %__MODULE__{}
      |> changeset(params)
    end
    def to_struct(%Ecto.Changeset{valid?: true} = changeset) do
      apply_changes(changeset)
    end
  end

  defmodule Store do
    @moduledoc """
    Store type
    """
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:reference, :string)
      field(:barcode_url, :string)
      field(:paybin_reference, :string)
      field(:barcode_paybin_url, :string)
    end
  end

  defmodule PaymentMethod do
    @moduledoc """
    Store type
    """
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:barcode_url, :string)
      field(:reference, :string)
      field(:type, :string)
    end
  end

  defmodule Fee do
    @moduledoc """
    Fee type
    """
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:amount, :float)
      field(:currency, :string)
      field(:tax, :float)
    end
  end

  defmodule Transaction do
    @moduledoc """
    Transaction type
    """
    use Ecto.Schema

    @primary_key {:id, :string, []}
    embedded_schema do
      field(:amount, :float)
      field(:authorization, :string)
      field(:conciliated, :boolean)
      field(:creation_date, :string)
      field(:currency, :string)
      # field :customer, Customer.t()
      field(:description, :string)
      field(:error_message, :string)
      belongs_to(:fee, Fee)
      field(:method, :string)

      field(:operation_date, :string)
      field(:operation_type, :string)
      field(:order_id, :string)

      belongs_to(:payment_method, PaymentMethod)
      field(:status, :string)
      field(:transaction_type, :string)
      # bank_account: BankAccount.t, card: Card.t, card_points: CardPoints.t
    end
  end

  defmodule WebhookPost do
    @moduledoc """
    Webhook type for post actions from openpay.
    """
    use Ecto.Schema

    embedded_schema do
      field(:event_date, :utc_datetime)
      belongs_to(:transaction, Transaction)
      field(:type, :string)
    end
  end
end
