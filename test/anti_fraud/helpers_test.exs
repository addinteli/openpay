defmodule AntiFraud.HelpersTest do
  @moduledoc """
  AntiFraud Tests
  """
  use ExUnit.Case, async: false
  alias Openpay.AntiFraud
  alias Openpay.AntiFraud.Helpers

  setup do
    {:ok, device_session_id: AntiFraud.get_device_session_id(), antifraud_key: "03293"}
  end

  @tag :antifraud
  test "render_components/1", %{device_session_id: device_session_id} do
    assert {:safe, html} = Helpers.render_components(device_session_id)
    assert html =~ device_session_id
  end

  @tag :antifraud
  test "render_antifraud_script/2", %{device_session_id: device_session_id, antifraud_key: antifraud_key} do
    assert {:safe, html} = Helpers.render_antifraud_script(device_session_id, antifraud_key)
    assert html =~ device_session_id
  end
end
