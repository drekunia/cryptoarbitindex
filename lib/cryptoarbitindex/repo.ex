defmodule CryptoArbitIndex.Repo do
  use Ecto.Repo,
    otp_app: :cryptoarbitindex,
    adapter: Ecto.Adapters.Postgres
end
