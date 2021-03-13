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

  @tag :charge_store
  test "should create a charge to openpay with customer node" do
    use_cassette "charge_with_customer" do
      expected = %{
        amount: 199.0,
        authorization: nil,
        creation_date: "2021-02-03T16:19:15-06:00",
        currency: "MXN",
        description: "An awesome package you bought",
        error_message: nil,
        id: "trjkktypvxhwcepfcer9",
        method: "store",
        operation_type: "in",
        status: "in_progress",
        transaction_type: "charge",
        conciliated: false,
        operation_date: "2021-02-03T16:19:15-06:00",
        payment_method: %{
          barcode_url:
            "https://sandbox-api.openpay.mx/barcode/1010101574043722?width=1&height=45&text=false",
          reference: "1010101574043722",
          type: "store"
        },
        customer: %{
          address: nil,
          clabe: nil,
          creation_date: "2021-02-03T16:19:15-06:00",
          email: "santi@gmail.com",
          external_id: "mycustom_id_10005",
          last_name: "Contreras",
          name: "Santiago",
          phone_number: "5523231818"
        },
        order_id: nil
      }

      response =
        %{
          amount: 199,
          description: "An awesome package you bought",
          customer: %{
            external_id: "mycustom_id_10005",
            name: "Santiago",
            last_name: "Contreras",
            email: "santi@gmail.com",
            phone_number: "5523231818"
          }
        }
        |> Types.ChargeStore.new_changeset()
        |> Types.ChargeStore.to_struct()
        |> Store.charge_commerce()

      assert expected == response
    end
  end

  @tag :charge_store
  test "should create a charge to openpay without customer node" do
    use_cassette "charge_without_customer" do
      response = %{
        amount: 258.0,
        authorization: nil,
        creation_date: "2020-03-09T22:53:10-06:00",
        currency: "MXN",
        description: "An awesome package you bought",
        error_message: nil,
        id: "trn3snoaw6tie1t11cvk",
        method: "store",
        operation_type: "in",
        status: "in_progress",
        transaction_type: "charge",
        conciliated: false,
        operation_date: "2020-03-09T22:53:10-06:00",
        payment_method: %{
          barcode_url:
            "https://sandbox-api.openpay.mx/barcode/1010103099601647?width=1&height=45&text=false",
          reference: "1010103099601647",
          type: "store"
        },
        customer: %{
          address: nil,
          clabe: nil,
          creation_date: "2020-03-09T22:53:10-06:00",
          email: "hello@company.com",
          external_id: "default-9.668317",
          last_name: "platform",
          name: "adm",
          phone_number: nil
        },
        order_id: nil
      }

      payload = %Types.ChargeStore{
        amount: 258,
        description: "An awesome package you bought"
      }

      assert response == Store.charge_commerce(payload)
    end
  end

  @tag :charge_store
  test "should get an error charge to openpay" do
    use_cassette "charge_with_customer_error" do
      response = %Openpay.Types.Commons.Error{
        category: "request",
        description: "The external_id already exists",
        error_code: 2003,
        fraud_rules: [],
        http_code: 409,
        request_id: "32a665fa-2eb2-498b-aad5-beb58fc997d1"
      }

      payload =
        %{
          amount: 929,
          description: "An awesome package you bought",
          customer:
            %{
              external_id: "mycustom_id_10000",
              name: "Santiago",
              last_name: "Contreras",
              email: "santi@gmail.com",
              phone_number: "5523231818"
            }
        }
        |> Types.ChargeStore.new_changeset()
        |> Types.ChargeStore.to_struct()

      assert response == Store.charge_commerce(payload)
    end
  end
end
