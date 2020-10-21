defmodule InfinWeb.PageLive do
  use InfinWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 1000)

    {:ok, assign(socket, time: DateTime.utc_now)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000)
    {:noreply, assign(socket, time: DateTime.utc_now)}
  end

  def handle_event("update", _value, socket) do
    {:noreply, assign(socket, time: DateTime.utc_now)}
  end
end
