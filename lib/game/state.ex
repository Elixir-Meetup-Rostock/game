defmodule Game.State do
  @moduledoc """
  The state of the game.

  Does the game-tick and handles all state e.g. players, map, items.
  Calculates changes and invokes updates (if needed) on each tick.
  """

  use GenServer

  alias Game.State.Players
  # alias GameWeb.Endpoint

  @tick_speed 2000

  # @moveTopic "movement"
  # @topic "players"

  # @movement_speed 10

  # boundaries for map
  # @x_min 0
  # @x_max 1920
  # @y_min 0
  # @y_max 1209

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)

    Players.start()
  end

  @impl true
  def init(_opts) do
    :timer.send_interval(@tick_speed, self(), :tick)

    {:ok, %{players: %{}}}
  end

  @impl true
  def handle_info(:tick, state) do
    # TODO
    # - for each (connected) player
    #   - check if key is pressed
    #     - true: add "speed" to position
    #     - false: skip
    # - for each arrows
    #   - calculate new positions
    # ##### if all movements habve been caculated ####
    # - collision check
    # - broadcast new positions

    {:noreply, state}
  end

  def list_players() do
    Players.list()
  end

  def get_player(id) do
    Players.get(id)
  end

  def add_player(id, data) do
    Players.add(id, data)
  end

  def remove_player(id) do
    Players.remove(id)
  end

  def player_start_action(action, id) do
    Players.start_action(id, action)
  end

  def player_stop_action(action, id) do
    Players.stop_action(id, action)
  end

  # @impl true
  # def handle_cast({:start_move_player, _player_id, _action}, state) do
  #   # player_id
  #   # |> get_player()
  #   # |> update_player(action, :start)

  #   {:noreply, state}
  # end

  # def handle_cast({:stop_move_player, _player_id, _action}, state) do
  #   # player_id
  #   # |> get_player()
  #   # |> update_player(action, :stop)

  #   {:noreply, state}
  # end

  # @impl true
  # def handle_call({:move_player, player_id, key}, _from, state) do
  #   player = Map.get(state.players, player_id)

  #   new_player =
  #     player
  #     |> get_new_position(key)

  #   Endpoint.broadcast(@moveTopic, "move", %{id: player_id, player: player})

  #   {:reply, :ok, Map.put(state, :players, Map.put(state.players, player_id, new_player))}
  # end

  # # def handle_call({:start_move_player, player_id, key}, _from, state) do
  # # new_val = Map.new([{key, true}])

  # # state.players
  # # |> Map.get(player_id)
  # # |> update_in(:keys, &Map.merge(&1, new_val))
  # # |> Map.get(:keys)
  # # |> IO.inspect(label: "start_move_player")
  # # end

  # # def handle_call({:stop_move_player, _player_id, key}, _from, state) do
  # # new_val = Map.new([{key, false}])

  # # state.players
  # # |> Map.get(player_id)
  # # |> update_in(:keys, &Map.merge(&1, new_val))
  # # |> Map.get(:keys)
  # # |> IO.inspect(label: "stop_move_player")
  # # end

  # @impl true
  # def handle_call(:list_players, _from, state) do
  #   {:reply, state, state}
  # end

  # @impl true
  # def handle_call({:get_player, player_id}, _from, state) do
  #   {:reply, Map.get(state.players, player_id), state}
  # end

  # defp get_new_position(player, "w") when player.y - @movement_speed >= @y_min do
  #   %{player | y: player.y - @movement_speed}
  # end

  # defp get_new_position(player, "s") when player.y + @movement_speed <= @y_max do
  #   %{player | y: player.y + @movement_speed}
  # end

  # defp get_new_position(player, "a") when player.x - @movement_speed >= @x_min do
  #   %{player | x: player.x - @movement_speed}
  # end

  # defp get_new_position(player, "d") when player.x + @movement_speed <= @x_max do
  #   %{player | x: player.x + @movement_speed}
  # end

  # defp get_new_position(player, _key), do: player

  # defp get_color(name) do
  #   hue = name |> to_charlist() |> Enum.sum() |> rem(360)
  #   "hsl(#{hue}, 60%, 40%)"
  # end
end
