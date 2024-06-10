defmodule CryptoArbitIndex.Price.Indodax do
  use Ecto.Schema
  import Ecto.Changeset

  schema "indodax_prices" do
    field :high, :float
    field :low, :float
    field :pair, :string
    field :last, :float
    field :buy, :float
    field :sell, :float
    field :vol_idr, :float
    field :server_time, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(indodax, attrs) do
    indodax
    |> cast(attrs, [:pair, :high, :low, :last, :buy, :sell, :vol_idr, :server_time])
    |> validate_required([:pair, :high, :low, :last, :buy, :sell, :vol_idr, :server_time])
  end
end
