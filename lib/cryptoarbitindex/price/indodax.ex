defmodule CryptoArbitIndex.Price.Indodax do
  use Ecto.Schema
  import Ecto.Changeset

  schema "indodax_prices" do
    field :high, :float
    field :low, :float
    field :pair, :string
    field :last_price, :float
    field :buy, :float
    field :sell, :float
    field :volume_idr, :float
    field :server_time, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(indodax, attrs) do
    indodax
    |> cast(attrs, [:pair, :high, :low, :last_price, :buy, :sell, :volume_idr, :server_time])
    |> validate_required([:pair, :high, :low, :last_price, :buy, :sell, :volume_idr, :server_time])
  end
end
