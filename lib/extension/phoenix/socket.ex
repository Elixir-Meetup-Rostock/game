defmodule Extension.Phoenix.Socket do
  @moduledoc """
  Instead of {:ok, socket} or {:noreply, socket}
  you can now write socket |> reply(:ok)
  e.g.
  socket
  |> assign(a: "1")
  |> assign(b: "2")
  |> assign(c: "3")
  |> reply(:ok)
  """

  def reply(socket, reply) when is_atom(reply), do: {reply, socket}
end
