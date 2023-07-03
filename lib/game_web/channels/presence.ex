defmodule GameWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :game,
    pubsub_server: Game.PubSub

  alias Game.State

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_metas(_topic, %{joins: joins, leaves: leaves}, _presences, state) do
    for {id, presence} <- joins do
      meta = presence |> get_presence_meta()

      State.add_player(id, meta)
    end

    for {id, _presence} <- leaves do
      State.remove_player(id)
    end

    {:ok, state}
  end

  defp get_presence_meta(%{metas: [meta | _]}), do: meta
end
