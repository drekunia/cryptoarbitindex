defmodule CryptoArbitIndex.Price.Bitfinex do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bitfinex_prices" do
    field :high, :float
    field :low, :float
    field :pair, :string
    field :last_price, :float
    field :buy, :float
    field :sell, :float
    field :volume_usd, :float
    field :server_time, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bitfinex, attrs) do
    bitfinex
    |> cast(attrs, [:pair, :high, :low, :last_price, :buy, :sell, :volume_usd, :server_time])
    |> validate_required([:pair, :high, :low, :last_price, :buy, :sell, :volume_usd, :server_time])
  end
end
