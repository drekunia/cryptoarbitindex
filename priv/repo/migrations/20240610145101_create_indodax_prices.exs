defmodule CryptoArbitIndex.Repo.Migrations.CreateIndodaxPrices do
  use Ecto.Migration

  def change do
    create table(:indodax_prices) do
      add :pair, :string
      add :high, :float
      add :low, :float
      add :last, :float
      add :buy, :float
      add :sell, :float
      add :vol_idr, :float
      add :server_time, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
