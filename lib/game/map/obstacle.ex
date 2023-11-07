defmodule Game.Map.Obstacle do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :id, :string
    field :x, :integer
    field :y, :integer
    field :z, :integer
    field :width, :integer
    field :height, :integer
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
  def changeset(obstacle, attrs \\ %{}) do
    obstacle
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
