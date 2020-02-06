defmodule Openpay.Charge.StoreTest do
  @moduledoc """
  This module is our test for store charges
  """
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Openpay.Charge.Store
  alias Openpay.Types

  setup do
    ExVCR.Config.cassette_library_dir("fixture/charges")
    :ok
  end

  test "should create a charge to openpay with customer node" do
    use_cassette "charge_with_customer" do
      response = %{
        amount: 748.0,
        authorization: nil,
        creation_date: "2019-07-11T16:46:47-05:00",
        currency: "MXN",
        description: "An awesome package you bought",
        error_message: nil,
        id: "truthabr8i7jzw3xtu3i",
        method: "store",
        operation_type: "in",
        status: "in_progress",
        transaction_type: "charge",
        conciliated: false,
        operation_date: "2019-07-11T16:46:47-05:00",
        payment_method: %{
          barcode_url:
            "https://sandbox-api.openpay.mx/barcode/1010100764807120?width=1&height=45&text=false",
          reference: "1010100764807120",
          type: "store"
        },
        customer: %{
          address: nil,
          clabe: nil,
          creation_date: "2019-07-11T16:46:47-05:00",
          email: "santi@gmail.com",
          external_id: "mycustom_id_00002",
          last_name: "Contreras",
          name: "Santiago",
          phone_number: "5523231818"
        },
        order_id: nil
      }

      payload = %Types.Request.ChargeStore{
        amount: 748,
        description: "An awesome package you bought",
        customer: %Types.Request.Customer{
          external_id: "mycustom_id_00003",
          name: "Santiago",
          last_name: "Contreras",
          email: "santi@gmail.com",
          phone_number: "5523231818"
        }
      }

      assert response == Store.charge_commerce(payload)
    end
  end

  test "should create a charge to openpay without customer node" do
    use_cassette "charge_without_customer" do
      response = %{
        amount: 258.0,
        authorization: nil,
        creation_date: "2019-07-11T15:46:49-05:00",
        currency: "MXN",
        description: "An awesome package you bought",
        error_message: nil,
        id: "trlzoucill9fzxzfn0wy",
        method: "store",
        operation_type: "in",
        status: "in_progress",
        transaction_type: "charge",
        conciliated: false,
        operation_date: "2019-07-11T15:46:49-05:00",
        payment_method: %{
          barcode_url:
            "https://sandbox-api.openpay.mx/barcode/1010103666047857?width=1&height=45&text=false",
          reference: "1010103666047857",
          type: "store"
        },
        customer: %{
          address: nil,
          clabe: nil,
          creation_date: "2019-07-11T15:46:49-05:00",
          email: "hello@company.com",
          external_id: "default-48.711036",
          last_name: "platform",
          name: "adm",
          phone_number: nil
        },
        order_id: nil
      }

      payload = %Types.Request.ChargeStore{
        amount: 258,
        description: "An awesome package you bought"
      }

      assert response == Store.charge_commerce(payload)
    end
  end

  test "should get an error charge to openpay" do
    use_cassette "charge_with_customer_error" do
      response = %Openpay.Types.Commons.Error{
        category: "request",
        description: "The external_id already exists",
        error_code: 2003,
        fraud_rules: [],
        http_code: 409,
        request_id: "92f7ff63-b8b4-4c00-a357-bc160d095fb2"
      }

      payload = %Types.Request.ChargeStore{
        amount: 748,
        description: "An awesome package you bought",
        customer: %Types.Request.Customer{
          external_id: "mycustom_id_00001",
          name: "Santiago",
          last_name: "Contreras",
          email: "santi@gmail.com",
          phone_number: "5523231818"
        }
      }

      assert response == Store.charge_commerce(payload)
    end
  end
end
