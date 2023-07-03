defmodule GameWeb.MovementLive.Index do
  use GameWeb, :live_view

  alias Game.State
  alias GameWeb.Endpoint
  alias GameWeb.Presence

  @topic_presence "player_presence"
  @topic_update "players_update"

  @impl true
  def mount(%{"user" => %{"name" => name}}, _session, socket) do
    if connected?(socket) do
      data = %{name: name}
      Presence.track(self(), @topic_presence, socket.id, data)

      Endpoint.subscribe(@topic_update)
    end

    socket
    |> assign(player: State.get_player(socket.id))
    |> assign(players: list_other_players(socket.id))
    |> reply(:ok)
  end

  def mount(_params, _session, socket) do
    socket |> redirect(to: ~p"/lobby") |> reply(:ok)
  end

  @impl true
  def handle_event("keyDown", %{"key" => key}, socket) do
    key |> get_key_action() |> State.player_start_action(socket.id)

    socket
    |> reply(:noreply)
  end

  def handle_event("keyUp", %{"key" => key}, socket) do
    key |> get_key_action() |> State.player_stop_action(socket.id)

    socket
    |> reply(:noreply)
  end

  def handle_event("click", _params, socket) do
    socket
    |> reply(:noreply)
  end

  @impl true
  def handle_info({:join, _id, _player}, socket) do
    socket
    |> assign(players: list_other_players(socket.id))
    |> reply(:noreply)
  end

  def handle_info({:leave, _id, nil}, socket) do
    socket
    |> assign(players: list_other_players(socket.id))
    |> reply(:noreply)
  end

  defp list_other_players(id) do
    State.list_players()
    |> Enum.reject(&(&1.id === id))
  end

  defp get_key_action("ArrowUp"), do: :up
  defp get_key_action("ArrowLeft"), do: :left
  defp get_key_action("ArrowRight"), do: :right
  defp get_key_action("ArrowDown"), do: :down

  defp get_key_action("w"), do: :up
  defp get_key_action("a"), do: :left
  defp get_key_action("d"), do: :right
  defp get_key_action("s"), do: :down

  defp get_key_action(" "), do: :space

  defp get_key_action(_key), do: nil
end
