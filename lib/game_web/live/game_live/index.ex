defmodule GameWeb.GameLive.Index do
  use GameWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    #if connected?(socket) do
    #end

    {:ok, socket}
  end
end
