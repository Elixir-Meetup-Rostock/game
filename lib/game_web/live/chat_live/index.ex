defmodule GameWeb.ChatLive.Index do
  use GameWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> reply(:ok)
  end
end
