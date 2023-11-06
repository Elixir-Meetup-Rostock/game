defmodule GameWeb.HomeLive.Index do
  use GameWeb, :live_view

  alias Game.State
  alias GameWeb.Endpoint

  @topic_update "players_update"

  @impl true
  def mount(_params, session, socket) do
    Endpoint.subscribe(@topic_update)

    IO.inspect(session)

    # form = to_form(%{"name" => nil}, as: "user")

    socket
    # |> assign(form: form)
    |> assign(players: State.list_players())
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
