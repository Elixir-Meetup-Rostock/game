defmodule GameWeb.MovementLive.Index do
  use GameWeb, :live_view

  alias GameWeb.Endpoint
  alias GameWeb.Presence

  alias Game.PlayerState

  @moveTopic "movement"
  @topic "players"

  @impl true
  def mount(%{"user" => %{"name" => name}}, _session, socket) do
    if connected?(socket) do
      meta = %{id: socket.id, name: name, color: getColor(name)}
      Presence.track(self(), @topic, socket.id, meta)
      PlayerState.add_player(socket.id, name)

      Endpoint.subscribe(@topic)
      Endpoint.subscribe(@moveTopic)
    end

    players_presence = list_presences(@topic)

    players =
      PlayerState.list_players().players
      |>  filter_players(players_presence)

      socket
      |> assign(player: PlayerState.get_player(socket.id))
      |> assign(players: players)
      |> reply(:ok)


  end

  def mount(_params, _session, socket) do
    socket |> redirect(to: ~p"/lobby") |> reply(:ok)
  end

  defp filter_players(player_map, active_players) do
    active_players
    |> Enum.map(& &1.id)
    |> Enum.map(fn id -> Map.get(player_map, id) end)
  end

  @impl true
  def handle_event("move", %{"key" => key}, socket) do
    PlayerState.move_player(socket.id, key)

    player = PlayerState.get_player(socket.id)

    socket
    |> assign(player: player)
    |> reply(:noreply)
  end

  @impl true
  def handle_info(%{event: "move", payload: %{id: _id, player: _player}}, socket) do
    players_presence = list_presences(@topic)

    players =
      PlayerState.list_players().players
      |>  filter_players(players_presence)

    socket
    |> assign(players: players)
    |> reply(:noreply)
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    {:ok, _} =
      Presence.track(socket, socket.assigns.user_id, %{
        online_at: inspect(System.system_time(:second))
      })

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

  defp getColor(name) do
    hue = name |> to_charlist() |> Enum.sum() |> rem(360)
    "hsl(#{hue}, 60%, 40%)"
  end
end
