defmodule Game.PlayerState do
  # implement genserver here
  use GenServer

  alias GameWeb.Endpoint

  @moveTopic "movement"

  # @moveTopic "movement"
  # @topic "players"

  @movement_speed 10

  # boundaries for map
  @x_min 0
  @x_max 1920
  @y_min 0
  @y_max 1209

  # player stats
  @default_hp 100

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_player(player_id, player_name) do
    GenServer.call(__MODULE__, {:add_player, player_id, player_name})
  end

  def remove_player(player_id) do
    GenServer.call(__MODULE__, {:remove_player, player_id})
  end

  def move_player(player_id, key) do
    GenServer.call(__MODULE__, {:move_player, player_id, key})
  end

  def list_players() do
    GenServer.call(__MODULE__, :list_players)
  end

  def get_player(player_id) do
    GenServer.call(__MODULE__, {:get_player, player_id})
  end

  @impl true
  def init(:ok) do
    {:ok, %{players: %{}}}
  end

  @impl true
  def handle_call({:add_player, player_id, player_name}, _from, state) do
    x_start = Enum.random(@x_min..div(@x_max, @movement_speed)) * @movement_speed
    y_start = Enum.random(@y_min..div(@y_max, @movement_speed)) * @movement_speed

    {:reply, :ok,
     Map.put(
       state,
       :players,
       Map.put(state.players, player_id, %{
         id: player_id,
         name: player_name,
         x: x_start,
         y: y_start,
         color: get_color(player_name),
         hp: @default_hp
       })
     )}
  end

  @impl true
  def handle_call({:remove_player, player_id}, _from, state) do
    {:reply, :ok, Map.put(state, :players, Map.delete(state.players, player_id))}
  end

  @impl true
  def handle_call({:move_player, player_id, key}, _from, state) do
    player = Map.get(state.players, player_id)
    new_player = get_new_position(player, key)

    Endpoint.broadcast(@moveTopic, "move", %{id: player_id, player: player})

    {:reply, :ok, Map.put(state, :players, Map.put(state.players, player_id, new_player))}
  end

  @impl true
  def handle_call(:list_players, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:get_player, player_id}, _from, state) do
    {:reply, Map.get(state.players, player_id), state}
  end

  defp get_new_position(player, "w") when player.y - @movement_speed >= @y_min do
    %{player | y: player.y - @movement_speed}
  end

  defp get_new_position(player, "s") when player.y + @movement_speed <= @y_max do
    %{player | y: player.y + @movement_speed}
  end

  defp get_new_position(player, "a") when player.x - @movement_speed >= @x_min do
    %{player | x: player.x - @movement_speed}
  end

  defp get_new_position(player, "d") when player.x + @movement_speed <= @x_max do
    %{player | x: player.x + @movement_speed}
  end

  defp get_new_position(player, _key), do: player

  defp get_color(name) do
    hue = name |> to_charlist() |> Enum.sum() |> rem(360)
    "hsl(#{hue}, 60%, 40%)"
  end
end
