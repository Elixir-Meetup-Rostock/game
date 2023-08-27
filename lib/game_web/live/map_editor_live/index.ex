defmodule GameWeb.MapEditorLive.Index do
  use GameWeb, :live_view

  @tile_size 16
  @default_width 30
  @default_height 30

  # @layers [:bottom, :top]

  @available_tiles [
    %{
      tile: :grass,
      name: "Grass",
      src: "https://opengameart.org/sites/default/files/grass_0.png"
    },
    %{
      tile: :water,
      name: "Water",
      src: "https://opengameart.org/sites/default/files/water_0.png"
    },
    %{
      tile: :tree,
      name: "Tree",
      src: "https://opengameart.org/sites/default/files/tree_0.png"
    },
    %{
      tile: :rock,
      name: "Rock",
      src: "https://opengameart.org/sites/default/files/rock_0.png"
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(:width, @default_width)
    |> assign(:height, @default_height)
    |> assign(:zoom, 1)
    |> assign(:tile_size, @tile_size)
    |> assign(:available_tiles, @available_tiles)
    |> assign(:tiles, {})
    |> assign(:bottom_layer, %{})
    |> assign(:top_layer, %{})
    |> assign(:active_layer, :bottom)
    |> assign(:selected_tile, @available_tiles |> List.first())
    |> reply(:ok)
  end

  @impl true
  def handle_event("update", %{"tiles" => tiles}, socket) do
    {:noreply, assign(socket, :tiles, tiles)}
  end

  @impl true
  def handle_event("update", %{"width" => width, "height" => height}, socket) do
    socket
    |> assign(:width, width)
    |> assign(:height, height)
    |> reply(:noreply)
  end

  @impl true
  def handle_event("update", %{"tile_size" => tile_size}, socket) do
    {:noreply, assign(socket, :tile_size, tile_size)}
  end

  @impl true
  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, :tiles, %{})}
  end

  @impl true
  def handle_event("change_layer", %{"layer" => layer}, socket) do
    {:noreply, assign(socket, :active_layer, layer)}
  end

  def handle_event(
        "set_tile",
        %{
          "tile" => tile
        },
        socket
      ) do
    atom_tile =
      tile
      |> String.to_existing_atom()

    socket
    |> assign(:selected_tile, atom_tile)
    |> reply(:noreply)
  end

  def handle_event(
        "switch_layer",
        %{
          "layer" => layer
        },
        socket
      ) do
    socket
    |> set_layer(layer)
    |> reply(:noreply)
  end

  def handle_event(
        "map_updated",
        %{
          "bottom_layer" => bottom_layer,
          "top_layer" => top_layer,
          "active_layer" => active_layer
        },
        socket
      ) do
    socket
    |> assign(:bottom_layer, bottom_layer)
    |> assign(:top_layer, top_layer)
    |> assign(:active_layer, active_layer)
    |> reply(:noreply)
  end

  def handle_event(
        "set_map_size",
        %{
          "map-width" => width,
          "map-height" => height
        },
        socket
      ) do
    socket
    |> assign_if_integer(:width, width)
    |> assign_if_integer(:height, height)
    |> reply(:noreply)
  end

  def handle_event("set_zoom", %{"zoom" => zoom}, socket) do
    socket
    |> assign(:zoom, Float.parse(zoom) |> elem(0))
    |> reply(:noreply)
  end

  def handle_event("save", _data, socket) do
    bottom_layer = socket.assigns[:bottom_layer]
    top_layer = socket.assigns[:top_layer]
    width = socket.assigns[:width]
    height = socket.assigns[:height]
    tile_size = socket.assigns[:tile_size]

    map = %{
      bottom_layer: bottom_layer,
      top_layer: top_layer,
      width: width,
      height: height,
      tile_size: tile_size
    }

    File.write!("map.json", Jason.encode!(map))

    {:noreply, socket}
  end

  defp assign_if_integer(socket, key, value) do
    case Integer.parse(value) do
      {:error, _} ->
        socket

      {new_value, _} ->
        assign(socket, key, new_value)
    end
  end

  defp set_layer(socket, "bottom"), do: socket |> assign(:active_layer, :bottom)
  defp set_layer(socket, "top"), do: socket |> assign(:active_layer, :top)
  defp set_layer(socket, _), do: socket

  defp get_tile(tile_name) do
    @available_tiles
    |> Enum.find(fn %{tile: t} -> t == tile_name end)
    |> case do
      nil -> @available_tiles |> List.first()
      tile -> tile
    end
  end

  defp get_tile_image(tile) do
    tile
    |> Map.get(:src)
    |> IO.inspect()
  end
end

# TODO: nur updates statt ganze layer zum server senden
# TODO: layer in file abspeichern als json und wieder aufrufen
# clear button, tile previews sidebar, layer switch, ...
