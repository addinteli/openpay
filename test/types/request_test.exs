defmodule Openpay.Types.CommonsTest do
  @moduledoc """
  Request Test
  """
  use ExUnit.Case, async: true

  alias Openpay.Utils.Commons
  alias Openpay.Types.Commons.{PaymentMethod, Transaction}

  test "response transacion to Transaction Response" do
    body_response = %{
      amount: 258.0,
      authorization: nil,
      #
      conciliated: false,
      creation_date: "2019-07-11T13:14:34-05:00",
      currency: "MXN",
      customer: %{
        address: nil,
        clabe: nil,
        creation_date: "2019-07-11T13:14:34-05:00",
        email: "hello@company.com",
        external_id: "test-34.110356",
        last_name: "platform",
        name: "adm",
        phone_number: nil
      },
      description: "An awesome package you bought",
      error_message: nil,
      id: "trqgfmysdhq2usrovjzp",
      method: "store",
      operation_date: "2019-07-11T13:14:34-05:00",
      operation_type: "in",
      order_id: nil,
      payment_method: %PaymentMethod{
        barcode_url:
          "https://sandbox-api.openpay.mx/barcode/1010102685686668?width=1&height=45&text=false",
        reference: "1010102685686668",
        type: "store"
      },
      status: "in_progress",
      transaction_type: "charge"
    }

    response = %Transaction{
      amount: 258.0,
      authorization: nil,
      creation_date: "2019-07-11T13:14:34-05:00",
      currency: "MXN",
      description: "An awesome package you bought",
      error_message: nil,
      id: "trqgfmysdhq2usrovjzp",
      method: "store",
      operation_type: "in",
      status: "in_progress",
      transaction_type: "charge",
      conciliated: false,
      operation_date: "2019-07-11T13:14:34-05:00",
      payment_method: %PaymentMethod{
        barcode_url:
          "https://sandbox-api.openpay.mx/barcode/1010102685686668?width=1&height=45&text=false",
        reference: "1010102685686668",
        type: "store"
      }
    }

    assert response == Commons.into(Transaction, body_response)
  end
end
