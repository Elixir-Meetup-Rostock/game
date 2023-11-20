defmodule GameWeb.HomeLive.Index do
  use GameWeb, :live_view

  alias Game.Accounts
  alias Game.State
  alias GameWeb.Endpoint

  @topic_update "players_update"

  @impl true
  def mount(_params, session, socket) do
    Endpoint.subscribe(@topic_update)

    socket
    |> assign(players: State.list_players())
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
end
