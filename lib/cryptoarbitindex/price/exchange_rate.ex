defmodule CryptoArbitIndex.Price.ExchangeRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "exchange_rates" do
    field :high, :float
    field :low, :float
    field :source, :string
    field :pair, :string
    field :last_price, :float
    field :buy, :float
    field :sell, :float
    field :volume_usd, :float
    field :server_time, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exchange_rate, attrs) do
    exchange_rate
    |> cast(attrs, [:pair, :high, :low, :last_price, :buy, :sell, :volume_usd, :server_time, :source])
    |> validate_required([:pair, :high, :low, :last_price, :buy, :sell, :volume_usd, :server_time, :source])
  end
end
