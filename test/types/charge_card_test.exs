defmodule Types.ChargeCardTest do
  @moduledoc """
  Charge Card Test
  """
  use ExUnit.Case, async: true

  alias Openpay.Types

  @tag :type_charge_card
  test "should get a valid changeset without payment plan" do
    payload =
      %{
        amount: 748,
        description: "An awesome package you bought",
        source_id: "SignedToken",
        cvv2: "1234",
        device_session_id: "randomDeviceId",
        currency: "MXN",
        order_id: "OrderID",
        customer:
          %{
            external_id: "my.custom_id_00003",
            name: "Santiago",
            last_name: "Contreras",
            email: "santi@gmail.com",
            phone_number: "5523231818"
          }
      }
      |> Types.ChargeCard.new_changeset()
      |> Types.ChargeCard.to_struct()

    assert %Types.ChargeCard{amount: 748.0} = payload
    assert is_nil(payload.payment_plan)
    assert %Openpay.Types.Customer{} = payload.customer
  end

  @tag :type_charge_card
  test "should get a valid changeset with payment plan" do
    payload =
      %{
        amount: 748,
        description: "An awesome package you bought",
        source_id: "SignedToken",
        cvv2: "1234",
        device_session_id: "randomDeviceId",
        currency: "MXN",
        order_id: "OrderID",
        payment_plan: %{
          payments: "18"
        },
        customer:
          %{
            external_id: "my.custom_id_00003",
            name: "Santiago",
            last_name: "Contreras",
            email: "santi@gmail.com",
            phone_number: "5523231818"
          }
          |> Types.Customer.new_changeset()
          |> Types.Customer.to_struct()
      }
      |> Types.ChargeCard.new_changeset()
      |> Types.ChargeCard.to_struct()

    assert %Types.ChargeCard{amount: 748.0} = payload
    refute is_nil(payload.payment_plan)
  end
end
