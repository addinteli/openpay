
defmodule AntiFraud.AntiFraudTest do
  @moduledoc """
  AntiFraud Test
  """
  use ExUnit.Case, async: false
  alias Openpay.AntiFraud

  setup  do
    {:ok, device_session_id: AntiFraud.get_device_session_id()}
  end
  @tag :antifraud
  test "get_device_session_id/0" do
    device_session_id = AntiFraud.get_device_session_id()
    assert String.length(device_session_id) == 32
  end

  @tag :antifraud
  test "get_antifraud_key/0" do
    assert AntiFraud.get_antifraud_key() == %{"data" => ""}
  end

  @tag :antifraud
  test "get_components/1", %{device_session_id: device_session_id} do
    assert AntiFraud.get_components(device_session_id) =~ device_session_id
  end
end
