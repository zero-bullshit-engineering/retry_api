defmodule RetryApi.Data.Position do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "positions" do

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [])
    |> validate_required([])
  end
end
