defmodule Game.Map.Tile do
  use Ecto.Schema

  import Ecto.Changeset

  @derive Jason.Encoder

  @primary_key false
  embedded_schema do
    field :id, :string
    field :sprite_id, :string
    field :x, :integer, default: 0
    field :y, :integer, default: 0
    field :z, :integer, default: 0
  end

  @fields [
    :id,
    :sprite_id,
    :x,
    :y,
    :z
  ]

  def to_struct(changeset), do: apply_changes(changeset)

  @doc false
  def changeset(tile, attrs \\ %{}) do
    tile
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
