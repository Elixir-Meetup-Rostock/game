defmodule Game.Map.Sprite do
  use Ecto.Schema

  import Ecto.Changeset

  @derive Jason.Encoder

  @default_size 16

  @primary_key false
  embedded_schema do
    field :id, :string
    field :src, :string
    field :width, :integer, default: @default_size
    field :height, :integer, default: @default_size
    field :frames, :integer, default: 1
    field :obstacle, :boolean, default: false
  end

  @fields [
    :id,
    :src,
    :width,
    :height,
    :frames,
    :obstacle
  ]

  def to_struct(changeset), do: apply_changes(changeset)

  @doc false
  def changeset(sprite, attrs \\ %{}) do
    sprite
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
