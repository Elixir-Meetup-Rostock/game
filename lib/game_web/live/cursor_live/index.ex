defmodule GameWeb.CursorLive.Index do
  use GameWeb, :live_view

  alias GameWeb.Endpoint
  alias GameWeb.Presence

  @topic "cursor"

  @impl true
  def mount(%{"user" => %{"name" => name}}, _session, socket) do
    if connected?(socket) do
      meta = %{id: socket.id, name: name, color: get_color(name)}
      Presence.track(self(), @topic, socket.id, meta)

      Endpoint.subscribe(@topic)
    end

    socket
    |> assign(players: list_presences(@topic))
    |> reply(:ok)
  end

  def mount(_params, _session, socket) do
    socket |> redirect(to: ~p"/") |> reply(:ok)
  end

  @impl true
  def handle_event("cursor-move", %{"x" => x, "y" => y}, socket) do
    update_presence(self(), @topic, socket.id, %{x: x, y: y})

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    # payload |> IO.inspect(label: "PAYLOAD")

    socket
    |> assign(players: list_presences(@topic))
    |> reply(:noreply)
  end

  def handle_info(:after_join, socket) do
    # IO.inspect("after_join")

    # {:ok, _} =
    #   Presence.track(socket, socket.assigns.user_id, %{
    #     online_at: inspect(System.system_time(:second))
    #   })

    socket
    |> reply(:noreply)
  end

  defp list_presences(topic) do
    topic
    |> Presence.list()
    |> Enum.map(&get_presence_meta/1)
  end

  defp get_presence_meta({_user_id, %{metas: [meta | _]}}), do: meta

  defp update_presence(pid, topic, key, payload) do
    metas =
      Presence.get_by_key(topic, key)[:metas]
      |> List.first()
      |> Map.merge(payload)

    Presence.update(pid, topic, key, metas)
  end

  defp get_color(name) do
    hue = name |> to_charlist() |> Enum.sum() |> rem(360)
    "hsl(#{hue}, 60%, 40%)"
  end
end
