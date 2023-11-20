defmodule Game.Map.Spawn do
  use Ecto.Schema

  import Ecto.Changeset

  @default_size 16

  @primary_key false
  embedded_schema do
    field :id, :string
    field :x, :integer
    field :y, :integer
    field :z, :integer
    field :width, :integer, default: @default_size
    field :height, :integer, default: @default_size
  end

  @fields [
    :id,
    :x,
    :y,
    :z,
    :width,
    :height
  ]

  def to_struct(changeset), do: apply_changes(changeset)

  @doc false
  def changeset(spawn, attrs \\ %{}) do
    spawn
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
