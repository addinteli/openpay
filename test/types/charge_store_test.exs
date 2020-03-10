defmodule Types.ChargeStoreTest do
  @moduledoc """
  Charge Store Test
  """
  use ExUnit.Case, async: true

  alias Openpay.Types

  @tag :type_charge_store
  test "should get a valid changeset" do
    payload =
      %{
        amount: 748,
        description: "An awesome package you bought",
        customer:
          %{
            external_id: "mycustom_id_00003",
            name: "Santiago",
            last_name: "Contreras",
            email: "santi@gmail.com",
            phone_number: "5523231818"
          }
          |> Types.Customer.new_changeset()
          |> Types.Customer.to_struct()
      }
      |> Types.ChargeStore.new_changeset()
      |> Types.ChargeStore.to_struct()

    assert %Types.ChargeStore{amount: 748.0} = payload
  end
end
