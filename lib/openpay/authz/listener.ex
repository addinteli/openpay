defmodule Openpay.Authz.Listener do
  # This module is the one responsible for listening to
  # authorize or refund events.
  @moduledoc false
  use GenServer, restart: :temporary

# server
  def init(state) do

    {:ok, state}
  end

# client
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, [name: __MODULE__])
  end
end
