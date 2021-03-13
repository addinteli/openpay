defmodule Openpay.Charge.CardTest do
  @moduledoc """
  This module is our test for store charges
  """
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Openpay.Charge.Card
  alias Openpay.Types

  setup do
    ExVCR.Config.cassette_library_dir("fixture/charges")
    :ok
  end

  @tag :card_token
  test "should create a token" do
    use_cassette "card with token" do
      response = %{
        id: "kjvec93fial2swoyye32",
        card: %{
          card_number: "411111XXXXXX1111",
          holder_name: "Juan Perez Ramirez",
          expiration_year: "20",
          expiration_month: "12",
          creation_date: nil,
          brand: "visa",
          address: nil
        }
      }

      payload = %{
        card_number: "4111111111111111",
        holder_name: "Juan Perez Ramirez",
        expiration_year: "20",
        expiration_month: "12",
        cvv2: "110"
      }
      |> Types.Token.new_changeset()
      |> Types.Token.to_struct()

      assert result = Card.create_token(payload)
      assert response.card == result.card
      refute is_nil(result.id)
      assert String.length(result.id) > 0
    end
  end

  @tag :charge_card
  test "should create a charge to openpay with customer node" do
    use_cassette "charge_with_card" do
      response = %{
        method: "card",
        operation_type: "in",
        status: "completed",
        transaction_type: "charge",
        amount: 748.0,
        authorization: "801585",
        card: %{
          address: nil,
          allows_charges: true,
          allows_payouts: true,
          bank_code: "002",
          bank_name: "Banamex",
          brand: "visa",
          card_number: "411111XXXXXX1111",
          expiration_month: "12",
          expiration_year: "25",
          holder_name: "Juan Perez Ramirez",
          type: "debit"
        },
        description: "Cargo inicial a mi cuenta",
        id: "trw1dksn7wcch8abcglt",
        order_id: "CH-00002",
        conciliated: false,
        currency: "MXN",
        customer: %{
          address: nil,
          clabe: nil,
          email: "juan.vazquez@empresa.com.mx",
          external_id: nil,
          last_name: "Vazquez Juarez",
          name: "Juan",
          phone_number: "4423456723",
          creation_date: "2020-01-27T11:26:53-06:00"
        },
        error_message: nil,
        creation_date: "2020-01-27T11:26:53-06:00",
        fee: %{
          amount: 24.19,
          currency: "MXN",
          tax: 3.8704
        },
        operation_date: "2020-01-27T11:26:55-06:00"
      }

      card = %{
        card_number: "4111111111111111",
        holder_name: "Juan Perez Ramirez",
        expiration_year: "25",
        expiration_month: "12",
        cvv2: "110"
      }
      |> Types.Token.new_changeset()
      |> Types.Token.to_struct()

      response_token = Card.create_token(card)
      val = System.system_time(:second)
      code = Integer.to_string(val)

      payload = %{
        source_id: response_token.id,
        amount: 748,
        currency: "MXN",
        description: "Cargo inicial a mi cuenta",
        order_id: "00005" <> code,
        device_session_id: "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f",
        cvv2: "110",
        customer: %{
          name: "Juan",
          last_name: "Vazquez Juarez",
          email: "juan.vazquez@empresa.com.mx",
          phone_number: "4423456723"
        }
      }
      |> Types.ChargeCard.new_changeset()
      |> Types.ChargeCard.to_struct()

      assert result = Card.charge(payload)
      assert response.card == result.card
      refute is_nil(result.id)
      assert String.length(result.id) > 0
    end
  end
end
