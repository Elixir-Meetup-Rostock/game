defmodule GameWeb.HomeLive.Index do
  use GameWeb, :live_view

  alias Game.Accounts
  alias Game.State
  alias GameWeb.Endpoint
  alias GameWeb.Presence

  @topic_update "players_update"
  @topic_presence "player_presence"

  @impl true
  def mount(_params, session, socket) do
    Endpoint.subscribe(@topic_update)
    Endpoint.subscribe(@topic_presence)

    player_count = Presence.list(@topic_presence) |> Map.keys() |> Enum.count()

    socket
    |> assign(players: State.list_players())
    |> assign(player_count: player_count)
    |> assign(me: Accounts.get_user_by_session_token(session["user_token"]))
    |> reply(:ok)
  end

  @impl true
  def handle_info({:join, _id, _player}, socket) do
    socket
    |> assign(players: State.list_players())
    |> reply(:noreply)
  end

  def handle_info({:leave, _id, nil}, socket) do
    socket
    |> assign(players: State.list_players())
    |> reply(:noreply)
  end

  def handle_info(
        %{
          event: "presence_diff",
          payload: %{
            joins: _joins,
            leaves: _leaves
          }
        },
        socket
      ) do
    socket
    |> assign(player_count: Presence.list(@topic_presence) |> Map.keys() |> Enum.count())
    |> reply(:noreply)
  end
end
