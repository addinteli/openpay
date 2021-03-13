defmodule Openpay.AntiFraud.Helpers do
  @moduledoc """
  Helpers, to work with Antifrauds.
  They are focus on bringing dependencies easily.

  To use them you require the module `Openpay.AntiFraud` to get
  the device_session_id and the antifraud_key.

  device_session_id = Openpay.AntiFraud.get_device_session_id()
  antifraud_key = Openpay.AntiFraud.get_antifraud_key()

  On your HTML
  <section>
    <div>My Custom Openpay Form</div>
    ...
    <%= Openpay.AntiFraud.Helpers.render_components(@device_session_id) %>
    <%= Openpay.AntiFraud.Helpers.render_antifraud_script(@device_session_id, @antifraud_key) %>
  </section>
  """
  alias Openpay.AntiFraud
  alias Openpay.ConfigState
  alias Openpay.ApiClient, as: Client

  def render_antifraud_script(device_session_id, antifraud_key) do
    antifraud_url = :api_env
    |> ConfigState.get_config()
    |> Client.get_endpoint()
    |> String.replace("v1", "antifraud/sc.js")

    html = """
      <script type="text/javascript">
        var _sift = window._sift = window._sift || [];
        _sift.push(['_setSessionId', "#{device_session_id}"]);
        _sift.push(['_setAccount', "#{antifraud_key}"]);
        _sift.push(['_trackPageview']);
      </script>
      <script type="text/javascript" async src="#{antifraud_url}"></script>
    """
    {:safe, html}
  end

  def render_components(device_session_id) do
    {:safe, AntiFraud.get_components(device_session_id)}
  end
end
