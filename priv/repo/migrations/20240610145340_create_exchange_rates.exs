defmodule CryptoArbitIndex.Repo.Migrations.CreateExchangeRates do
  use Ecto.Migration

  def change do
    create table(:exchange_rates) do
      add :pair, :string
      add :high, :float
      add :low, :float
      add :last_price, :float
      add :buy, :float
      add :sell, :float
      add :volume_usd, :float
      add :server_time, :integer
      add :source, :string

      timestamps(type: :utc_datetime)
    end
  end
end
