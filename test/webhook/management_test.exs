defmodule Webhook.ManagementTest do
  @moduledoc """
  Webhook Management Test
  """
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Openpay.Types

  setup do
    ExVCR.Config.cassette_library_dir("fixture/webhooks")
    :ok
  end

  @tag :webhook
  test "should create an webhook struct via openpay response" do
    # the url must be available and it must return 200 for GET/POST actions
    use_cassette "webhook_create" do
      payload =
        %{
          url: "https://pgw-op-hook.us.sysb.ai/charge-store",
          user: "FSQ82bKTqCTI4hr6w",
          password: "aBGVWR0eK1s56zYDfoFEsHuaZqaPxzUkRz",
          event_types: [
            "charge.created",
            "charge.succeeded"
          ]
        }
        |> Types.Webhook.new_changeset()
        |> Types.Webhook.to_struct()

      assert webhook = Openpay.Webhook.create(payload)
      assert %Types.Webhook{} = webhook

      assert "wynd5pcb9edpjb9l1dqp" == webhook.id
      assert "verified" == webhook.status
      refute webhook.allow_redirects
      refute webhook.force_host_ssl
    end
  end

  @tag :webhook
  test "retrieve a webhook" do
    use_cassette "webhook_get" do
      response = %Openpay.Types.Webhook{
        allow_redirects: false,
        event_types: ["charge.created", "charge.succeeded"],
        force_host_ssl: false,
        id: "wynd5pcb9edpjb9l1dqp",
        password: nil,
        status: "verified",
        url: "https://pgw-op-hook.us.sysb.ai/charge-store",
        user: "FSQ82bKTqCTI4hr6w"
      }

      assert response == Openpay.Webhook.get("wynd5pcb9edpjb9l1dqp")
    end
  end

  @tag :webhook
  test "retrieve all webhooks" do
    use_cassette "webhooks_list" do
      response = [
        %Openpay.Types.Webhook{
          allow_redirects: false,
          event_types: ["charge.created", "charge.succeeded"],
          force_host_ssl: false,
          id: "wynd5pcb9edpjb9l1dqp",
          password: nil,
          status: "verified",
          url: "https://pgw-op-hook.us.sysb.ai/charge-store",
          user: "FSQ82bKTqCTI4hr6w"
        }
      ]

      assert response == Openpay.Webhook.list()
    end
  end

  @tag :webhook
  test "delete a webhook" do
    use_cassette "webhook_deleted" do
      payload =
        %{
          url: "https://pgw-op-hook.us.sysb.ai/charge-store",
          user: "FSQ82bKTqCTI4hr6w2",
          password: "aBGVWR0eK1s56zYDfoFEsHuaZqaPxzUkRz2",
          event_types: [
            "charge.created"
          ]
        }
        |> Types.Webhook.new_changeset()
        |> Types.Webhook.to_struct()

      assert %Types.Webhook{id: id} = Openpay.Webhook.create(payload)

      assert "" == Openpay.Webhook.delete(id)
    end
  end
end
