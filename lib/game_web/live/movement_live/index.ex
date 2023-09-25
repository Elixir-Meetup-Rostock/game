defmodule GameWeb.MovementLive.Index do
  use GameWeb, :live_view

  alias Game.Board
  alias Game.State
  alias GameWeb.Endpoint
  alias GameWeb.Presence

  @topic_presence "player_presence"
  @topic_update "players_update"
  @topic_tick "tick"

  @impl true
  def mount(%{"user" => %{"name" => name}}, _session, socket) do
    if connected?(socket) do
      data = %{name: name}
      Presence.track(self(), @topic_presence, socket.id, data)

      State.add_player(socket.id, data)

      Endpoint.subscribe(@topic_update)
      Endpoint.subscribe(@topic_tick)
    end

    socket
    |> assign(loaded: false)
    |> assign(sprites: Board.list_sprites())
    |> assign(layers: Board.get_layers(socket.id))
    |> assign(player: Board.get_player(socket.id))
    |> reply(:ok)
  end

  def mount(_params, _session, socket) do
    socket |> redirect(to: ~p"/") |> reply(:ok)
  end

  @impl true
  def handle_event("sprites_loaded", _params, socket) do
    socket
    |> assign(loaded: true)
    |> reply(:noreply)
  end

  def handle_event("click", %{"xPos" => x, "yPos" => y}, socket) do
    %{id: player_id} = socket.assigns.player

    State.add_projectile(player_id, {x, y})

    socket
    |> reply(:noreply)
  end

  def handle_event("keyDown", %{"key" => key}, socket) do
    key |> get_key_action() |> State.set_player_action(true, socket.id)

    socket
    |> reply(:noreply)
  end

  def handle_event("keyUp", %{"key" => key}, socket) do
    key |> get_key_action() |> State.set_player_action(false, socket.id)

    socket
    |> reply(:noreply)
  end

  @impl true
  def handle_info({:join, _id, _player}, socket) do
    socket
    |> assign(layers: Board.get_layers(socket.id))
    |> reply(:noreply)
  end

  def handle_info({:leave, _id, nil}, socket) do
    socket
    |> assign(layers: Board.get_layers(socket.id))
    |> reply(:noreply)
  end

  def handle_info(:tick, socket) do
    socket
    |> assign(layers: Board.get_layers(socket.id))
    |> assign(player: Board.get_player(socket.id))
    |> reply(:noreply)
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
