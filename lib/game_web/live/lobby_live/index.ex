defmodule GameWeb.LobbyLive.Index do
  use GameWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{"name" => nil}, as: "user")

    socket
    |> assign(form: form)
    |> reply(:ok)
  end
end
