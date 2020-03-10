defmodule Types.CustomerTest do
  @moduledoc """
  Customer Type Test
  """
  use ExUnit.Case, async: true
  alias Openpay.Types

  @tag :wip
  test "should get a valid changeset" do
    params = %{name: "Daniel", email: "yeap@da.com"}
    assert changeset = Types.Customer.new_changeset(params)
    assert changeset.valid?
    assert %Types.Customer{} = Types.Customer.to_struct(changeset)
  end

  @tag :wip
  test "should get an invalid changeset" do
    params = %{name: "", email: "yeapda.com"}
    assert changeset = Types.Customer.new_changeset(params)
    refute changeset.valid?

    assert changeset.errors == [
             email: {"has invalid format", [validation: :format]},
             name: {"can't be blank", [validation: :required]}
           ]
  end
end
