defmodule CryptoArbitIndex.Repo.Migrations.CreateBitfinexPrices do
  use Ecto.Migration

  def change do
    create table(:bitfinex_prices) do
      add :pair, :string
      add :high, :float
      add :low, :float
      add :last_price, :float
      add :buy, :float
      add :sell, :float
      add :volume_usd, :float
      add :server_time, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
